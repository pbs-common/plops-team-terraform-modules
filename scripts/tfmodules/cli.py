"""CLI commands for the terraform modules management tool."""

import shutil
import sys
from datetime import datetime
from pathlib import Path

import click
from git import Repo
from rich.panel import Panel
from rich.table import Table
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn

from .constants import (
    CONFIG_FILE,
    CONFIG_EMPTY_FILE,
    LOCK_FILE,
    MODULES_DIR,
    RESOURCE_TO_MODULE_MAP,
    console,
)
from .config import load_config, save_config
from .lock import load_lock_file, remove_from_lock_file
from .utils import (
    validate_git_repo,
    get_latest_git_tags,
    get_local_version,
    parse_semver_safe,
    calculate_version_bump,
)
from .modules import (
    add_module,
    update_module,
    validate_config,
    print_module_version_changes,
)
from .readme import generate_readme
from .github_api import (
    get_pbs_common_terraform_modules,
    get_latest_module_version_from_github,
)
from .analyzer import (
    analyze_repository,
    match_module_to_pbs_common,
    clean_module_name,
    update_config_with_analyzed_modules,
)


@click.group()
def cli():
    """Terraform modules management tool."""
    pass


@cli.command(
    short_help="Validate repo and config.",
    help="Validate the current repository and configuration file. Checks that the repository is a valid git repo and that all modules and versions in config.yaml exist in their respective sources."
)
def validate():
    validate_git_repo()
    config = load_config()
    validate_config(config)


@cli.command(
    short_help="Initialize repo with modules.",
    help="Initialize the repository by adding all modules at the specified versions and update the lock file."
)
def init():
    validate_git_repo()
    config = load_config()

    if not config.get("modules"):
        console.print("[yellow]No modules defined in config.yaml. Nothing to initialize.[/yellow]")
        return

    validate_config(config)

    try:
        Repo(".")
    except Exception as e:
        console.print(f"[red]Failed to open git repo: {e}[/red]")
        sys.exit(1)

    MODULES_DIR.mkdir(exist_ok=True)

    # Track which modules were processed
    processed_modules = set()

    for m in config["modules"]:
        add_module(m)
        processed_modules.add(m["name"])

    # Clean up lock file entries for modules no longer in config
    lock_data = load_lock_file()
    if "modules" in lock_data:
        modules_to_remove = [
            name for name in lock_data["modules"].keys()
            if name not in processed_modules
        ]
        for name in modules_to_remove:
            console.print(f"[yellow]Removing {name} from lock file (no longer in config)[/yellow]")
            remove_from_lock_file(name)

    console.print("[bold green]✓ Initialization complete[/bold green]")


@cli.command(
    short_help="Generate README.md for modules.",
    help="Generate a README.md summarizing the modules and their versions from config.yaml."
)
def readme():
    config = load_config()
    generate_readme(config)


@cli.command(
    short_help="Update modules.",
    help="Update all modules to the versions specified in config.yaml. Fetches latest tags and checks out the correct version for each module."
)
def update():
    config = load_config()

    if not config.get("modules"):
        console.print("[yellow]No modules defined in config.yaml. Nothing to update.[/yellow]")
        return

    changes = []

    for m in config["modules"]:
        old_version = get_local_version(m["name"])
        update_module(m)

        changes.append({
            "name": m["name"],
            "old_version": old_version,
            "new_version": m["version"],
            "lock": m.get("lock", False),
        })

    console.print("[bold green]✓ Modules updated[/bold green]")
    print_module_version_changes(changes)


@cli.command(
    short_help="Refresh config to latest module versions.",
    help="Refresh the config.yaml to use the latest available versions for each module. Bumps the config version (major if any module has a major update, minor if any module has a minor update)."
)
def refresh():
    config = load_config()

    if not config.get("modules"):
        console.print("[yellow]No modules defined in config.yaml. Nothing to refresh.[/yellow]")
        return

    changes = []
    bump_type = None  # Track highest bump type needed

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Fetching latest versions...", total=len(config["modules"]))

        for m in config["modules"]:
            try:
                tags = get_latest_git_tags(m["source"])
                latest = tags[-1] if tags else m["version"]
            except Exception as e:
                console.print(f"[red]Failed to get tags for {m['name']}: {e}[/red]")
                sys.exit(1)

            old_version = m["version"]
            is_locked = m.get("lock", False)

            if not is_locked:
                new_version = latest
                version_bump = calculate_version_bump(old_version, new_version)

                # Track highest bump type
                if version_bump == "major" and bump_type != "major":
                    bump_type = "major"
                elif version_bump == "minor" and bump_type not in ["major", "minor"]:
                    bump_type = "minor"
                elif version_bump == "patch" and not bump_type:
                    bump_type = "patch"
            else:
                new_version = old_version

            changes.append({
                "name": m["name"],
                "old_version": old_version,
                "new_version": new_version,
                "lock": is_locked,
            })

            m["version"] = new_version
            progress.advance(task)

    # Bump config version
    old_config_version = parse_semver_safe(str(config.get("version", "0.0.0")))
    if not old_config_version:
        console.print("[red]Invalid version in config[/red]")
        sys.exit(1)

    if bump_type == "major":
        new_config_version = old_config_version.bump_major()
    elif bump_type == "minor":
        new_config_version = old_config_version.bump_minor()
    elif bump_type == "patch":
        new_config_version = old_config_version.bump_patch()
    else:
        new_config_version = old_config_version

    config["version"] = str(new_config_version)
    save_config(config)

    console.print(
        Panel(
            f"[bold green]✓ Config refreshed[/bold green]\n"
            f"Version: {old_config_version} → {new_config_version}",
            title="Update Complete"
        )
    )
    print_module_version_changes(changes)


@cli.command(
    short_help="Cleanup modules and reset config.",
    help="Cleanup all module directories, backup current config.yaml, reset config.yaml to config_empty.yaml, and regenerate README."
)
@click.confirmation_option(prompt="Are you sure you want to cleanup all modules?")
def cleanup():
    """Cleanup all modules and reset configuration."""
    # Remove all module directories
    try:
        if MODULES_DIR.exists():
            module_dirs = [d for d in MODULES_DIR.iterdir() if d.is_dir()]

            if not module_dirs:
                console.print("[yellow]No modules to cleanup[/yellow]")
            else:
                for module_dir in module_dirs:
                    console.print(f"[yellow]🗑️  Removing module {module_dir.name}[/yellow]")
                    shutil.rmtree(module_dir, ignore_errors=True)

            # Remove empty modules directory
            if not any(MODULES_DIR.iterdir()):
                MODULES_DIR.rmdir()
                console.print(f"[green]✓ Removed empty {MODULES_DIR} directory[/green]")
    except Exception as e:
        console.print(f"[red]Failed to remove modules: {e}[/red]")
        sys.exit(1)

    # Remove lock file
    if Path(LOCK_FILE).exists():
        try:
            Path(LOCK_FILE).unlink()
            console.print(f"[green]✓ Removed {LOCK_FILE}[/green]")
        except Exception as e:
            console.print(f"[yellow]Warning: Could not remove lock file: {e}[/yellow]")

    # Backup config.yaml
    if Path(CONFIG_FILE).exists():
        try:
            date_str = datetime.now().strftime("%Y%m%d-%H%M%S")
            backup_file = f"config-{date_str}.yaml"
            shutil.copy(CONFIG_FILE, backup_file)
            console.print(f"[green]✓ Backed up config.yaml to {backup_file}[/green]")
        except Exception as e:
            console.print(f"[red]Failed to backup config.yaml: {e}[/red]")
            sys.exit(1)

    # Reset to empty config
    if not Path(CONFIG_EMPTY_FILE).exists():
        console.print(f"[yellow]⚠ {CONFIG_EMPTY_FILE} not found, skipping reset[/yellow]")
    else:
        try:
            shutil.copy(CONFIG_EMPTY_FILE, CONFIG_FILE)
            console.print(f"[green]✓ config.yaml reset to {CONFIG_EMPTY_FILE}[/green]")
        except Exception as e:
            console.print(f"[red]Failed to reset config.yaml: {e}[/red]")
            sys.exit(1)

    # Regenerate README with empty modules section
    try:
        config = load_config()
        generate_readme(config)
        console.print(f"[green]✓ README.md updated with empty modules section[/green]")
    except Exception as e:
        console.print(f"[yellow]Warning: Could not update README: {e}[/yellow]")

    console.print("\n[bold green]✓ Cleanup complete[/bold green]")


@cli.command(
    short_help="Analyze repos and update config with modules.",
    help="Analyze repositories specified in config.yaml to find Terraform modules and resources used, "
         "list available terraform-*-module repositories from pbs-common organization, "
         "match modules based on both module sources and resource types, "
         "and update config.yaml with latest versions. "
         "Repositories can be from any GitHub organization. "
         "Use --dry-run to preview changes without modifying config.yaml."
)
@click.option('--dry-run', is_flag=True, default=False, help='Preview changes without modifying config.yaml.')
def analyze(dry_run):
    """Analyze Terraform repositories and update config with required modules."""
    console.print(Panel.fit(
        "[bold cyan]Terraform Module Analyzer[/bold cyan]\n"
        "Analyzes repositories (from any org) and matches resources & module sources to pbs-common modules",
        border_style="cyan"
    ))

    # Step 1: Load config and check for repositories
    config = load_config()
    repos_to_analyze = config.get("repositories", [])

    if not repos_to_analyze:
        console.print("[yellow]No repositories specified in config.yaml. Nothing to analyze.[/yellow]")
        console.print("[cyan]Add a 'repositories' list to config.yaml:[/cyan]")
        console.print("""
repositories:
  - your-org/terraform-repo1
  - your-org/terraform-repo2
  - another-org/infrastructure-repo
""")
        return

    # Step 2: Get available pbs-common terraform modules
    console.print("\n[cyan]Fetching terraform modules from pbs-common organization...[/cyan]")

    try:
        available_modules = get_pbs_common_terraform_modules()
    except Exception as e:
        console.print(f"[red]Failed to fetch pbs-common modules: {e}[/red]")
        sys.exit(1)

    console.print(f"[green]Found {len(available_modules)} terraform modules in pbs-common organization[/green]\n")

    # Fetch latest versions for each module
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Fetching latest versions...", total=len(available_modules))

        for module in available_modules:
            version = get_latest_module_version_from_github(module["name"])
            module["latest_version"] = version
            progress.advance(task)

    # Sort modules by name for display
    sorted_modules = sorted(available_modules, key=lambda m: m["name"])

    # Display available modules
    table = Table(title="Available PBS Common Terraform Modules")
    table.add_column("Module Name", style="cyan")
    table.add_column("Latest Version", style="green")

    for module in sorted_modules:
        table.add_row(
            module["name"],
            module["latest_version"] or "unknown"
        )

    console.print(table)
    console.print()

    # Step 3: Analyze repositories
    console.print(f"[cyan]Analyzing {len(repos_to_analyze)} repositories...[/cyan]\n")

    # Step 4: Analyze each repository
    all_matched_modules = {}
    all_resources = set()
    all_module_sources = []

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Analyzing repositories...", total=len(repos_to_analyze))

        for repo in repos_to_analyze:
            progress.update(task, description=f"[cyan]Analyzing {repo.split('/')[-1]}...")
            results = analyze_repository(repo, available_modules)

            # Collect module sources found
            all_module_sources.extend(results["modules_used"])

            # Collect matched modules
            for module_name, module_info in results["matched_modules"].items():
                if module_name not in all_matched_modules:
                    all_matched_modules[module_name] = module_info

            # Collect resources
            all_resources.update(results["resources_used"])

            progress.advance(task)

    console.print(f"\n[green]✓ Analysis complete![/green]")
    console.print(f"[cyan]Found {len(all_module_sources)} module source references in .tf files[/cyan]")
    console.print(f"[cyan]Found {len(all_matched_modules)} unique pbs-common modules (matched from module sources and resource types)[/cyan]")
    console.print(f"[cyan]Found {len(all_resources)} unique resource types[/cyan]\n")

    # Display module sources found with match status
    if all_module_sources:
        console.print("[bold]Module Sources Found in Repositories:[/bold]")
        unique_sources = {}
        for source, version in all_module_sources:
            if source not in unique_sources:
                unique_sources[source] = version

        for source in sorted(unique_sources.keys()):
            # Use the same matching logic to check if matched
            matched_module = match_module_to_pbs_common(source, available_modules)
            if matched_module:
                status = f"[green]✓ matched to {matched_module['name']}[/green]"
            else:
                status = "[dim]not matched[/dim]"
            console.print(f"  • {source} {status}")
        console.print()

    # Display matched modules
    if all_matched_modules:
        matched_table = Table(title="Matched PBS Common Modules")
        matched_table.add_column("Module Name", style="cyan")
        matched_table.add_column("Latest Version", style="green")

        for module_name, module_info in sorted(all_matched_modules.items()):
            matched_table.add_row(
                module_name,
                module_info["latest_version"] or "unknown"
            )

        console.print(matched_table)
        console.print()

        modules_to_add = sorted(list(all_matched_modules.values()), key=lambda m: m["name"])
    else:
        console.print("[yellow]No matching pbs-common modules found in repositories. Nothing to update.[/yellow]")
        return

    # Filter out modules without a resolved version
    modules_to_add = [m for m in modules_to_add if m.get("latest_version")]
    if not modules_to_add:
        console.print("[yellow]All matched modules have no resolved version. Nothing to update.[/yellow]")
        return

    # Display resource summary
    if all_resources:
        console.print(f"\n[bold]Resource Types Found ({len(all_resources)} total):[/bold]")
        resource_list = sorted(all_resources)
        for resource in resource_list:
            if resource in RESOURCE_TO_MODULE_MAP:
                module_name = RESOURCE_TO_MODULE_MAP[resource]
                if module_name:
                    status = f"[green]✓ matched to {module_name}[/green]"
                else:
                    status = "[yellow]⚠ no module available[/yellow]"
            else:
                status = "[dim]not matched[/dim]"
            console.print(f"  • {resource} {status}")
        console.print()

    # Step 5: Update config
    if dry_run:
        console.print("[yellow]Dry run mode — config.yaml will not be modified.[/yellow]\n")
        console.print(f"[cyan]Would add/update {len(modules_to_add)} modules in config.yaml:[/cyan]")
        for module in modules_to_add:
            cleaned = clean_module_name(module["name"])
            console.print(f"  • {cleaned} @ {module['latest_version'] or 'unknown'}")
        console.print(f"\n[bold green]✓ Dry run complete![/bold green]")
        return

    console.print("[cyan]Updating config.yaml with modules...[/cyan]\n")

    # Create backup
    try:
        date_str = datetime.now().strftime("%Y%m%d-%H%M%S")
        backup_file = f"config-{date_str}.yaml"
        shutil.copy(CONFIG_FILE, backup_file)
        console.print(f"[green]✓ Backup created: {backup_file}[/green]")
    except Exception as e:
        console.print(f"[yellow]Warning: Could not create backup: {e}[/yellow]")

    config = update_config_with_analyzed_modules(config, modules_to_add)

    # Step 6: Save config
    save_config(config)

    console.print(f"\n[bold green]✓ Analysis and update complete![/bold green]")
    console.print(f"[cyan]Config file updated with {len(modules_to_add)} modules[/cyan]")
    console.print(f"\n[dim]Next steps:[/dim]")
    console.print(f"  [dim]1. Review config.yaml changes[/dim]")
    console.print(f"  [dim]2. Run './scripts/tfmodules.py init' to install modules[/dim]")
    console.print(f"  [dim]3. Run './scripts/tfmodules.py readme' to update documentation[/dim]")
