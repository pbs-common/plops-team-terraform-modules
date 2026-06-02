"""Module installation, updating, and validation operations."""

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, List

from rich.table import Table
from rich.progress import Progress, SpinnerColumn, TextColumn

from .constants import MODULES_DIR, EXCLUDED_MODULE_NAMES, EXCLUDED_MODULE_SUFFIXES, console
from .lock import update_lock_file
from .utils import get_latest_git_tags, get_local_version


def clone_and_checkout(module: Dict, temp_path: Path) -> None:
    """Clone a repository and checkout a specific version."""
    subprocess.run(
        ["git", "clone", "--quiet", module["source"], str(temp_path)],
        check=True,
        capture_output=True
    )

    subprocess.run(
        ["git", "-C", str(temp_path), "checkout", module["version"]],
        check=True,
        capture_output=True
    )


def copy_module_files(source_path: Path, dest_path: Path) -> None:
    """Copy all files from source to destination, excluding .git and unnecessary directories."""
    dest_path.mkdir(parents=True, exist_ok=True)

    for item in source_path.iterdir():
        if item.name == ".git" or item.name in EXCLUDED_MODULE_NAMES:
            continue
        if item.suffix in EXCLUDED_MODULE_SUFFIXES:
            continue
        if item.is_dir():
            shutil.copytree(item, dest_path / item.name, dirs_exist_ok=True)
        else:
            shutil.copy2(item, dest_path / item.name)


def install_module(module: Dict, dest_path: Path) -> None:
    """Install a module by cloning, copying files, and updating lock file."""
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir) / module["name"]

        try:
            clone_and_checkout(module, temp_path)
            copy_module_files(temp_path, dest_path)
            update_lock_file(module["name"], module["version"], module["source"])
        except subprocess.CalledProcessError as e:
            error_msg = e.stderr.decode() if e.stderr else str(e)
            raise RuntimeError(f"Git operation failed: {error_msg}")
        except Exception as e:
            raise RuntimeError(f"Installation failed: {e}")


def add_module(module: Dict) -> None:
    """Clone and copy module files to the modules directory."""
    path = MODULES_DIR / module["name"]
    if path.exists():
        console.print(f"[yellow]⚠ Module {module['name']} already exists[/yellow]")
        return

    console.print(f"[green]➕ Adding module[/green] {module['name']} @ {module['version']}")

    try:
        install_module(module, path)
        console.print(f"[green]✓ Module {module['name']} added successfully[/green]")
    except RuntimeError as e:
        console.print(f"[red]Failed to add module {module['name']}: {e}[/red]")
        if path.exists():
            shutil.rmtree(path, ignore_errors=True)
        sys.exit(1)


def update_module(module: Dict) -> None:
    """Update a module by re-cloning at the specified version."""
    path = MODULES_DIR / module["name"]

    console.print(f"[cyan]🔄 Updating[/cyan] {module['name']} → {module['version']}")

    # Remove existing module directory
    if path.exists():
        shutil.rmtree(path)

    try:
        install_module(module, path)
        console.print(f"[green]✓ Module {module['name']} updated successfully[/green]")
    except RuntimeError as e:
        console.print(f"[red]Failed to update module {module['name']}: {e}[/red]")
        console.print(f"[yellow]Hint: Verify that version {module['version']} exists in {module['source']}[/yellow]")
        sys.exit(1)


def validate_config(config: Dict) -> None:
    """Validate configuration and display results in a table."""
    if "modules" not in config or not config["modules"]:
        console.print("[yellow]No modules defined in config.yaml[/yellow]")
        sys.exit(0)

    table = Table(title="[bold cyan]Module Validation[/bold cyan]")
    table.add_column("Name", style="cyan")
    table.add_column("Source")
    table.add_column("Local Version")
    table.add_column("Config Version")
    table.add_column("Latest Version")
    table.add_column("Status")

    errors = []

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Validating modules...", total=len(config["modules"]))

        for m in config["modules"]:
            module_name = m.get("name", "unknown")
            module_source = m.get("source", "")
            config_version = m.get("version", "")

            if not module_name or not module_source or not config_version:
                errors.append(f"Invalid module configuration: {m}")
                table.add_row(
                    module_name,
                    module_source,
                    "",
                    config_version,
                    "",
                    "[red]Invalid config[/red]"
                )
                progress.advance(task)
                continue

            local_version = get_local_version(module_name)

            try:
                tags = get_latest_git_tags(module_source)
                latest = tags[-1] if tags else "N/A"

                if config_version not in tags:
                    errors.append(f"{module_name}: version {config_version} not found in source")
                    status = "[red]Version not found[/red]"
                else:
                    status = "[green]✓ OK[/green]"

                table.add_row(
                    module_name,
                    module_source,
                    local_version or "[dim]not initialized[/dim]",
                    config_version,
                    latest,
                    status
                )
            except Exception as e:
                errors.append(f"{module_name}: {e}")
                table.add_row(
                    module_name,
                    module_source,
                    local_version or "",
                    config_version,
                    "[red]error[/red]",
                    f"[red]{str(e)[:50]}[/red]"
                )

            progress.advance(task)

    console.print(table)

    if errors:
        console.print("\n[bold red]Validation errors:[/bold red]")
        for error in errors:
            console.print(f"  • {error}")
        sys.exit(1)


def print_module_version_changes(changes: List[Dict]) -> None:
    """Print a table of module version changes."""
    table = Table(title="[cyan]Module Version Changes[/cyan]")
    table.add_column("Module", style="cyan")
    table.add_column("Old Version")
    table.add_column("New Version")
    table.add_column("Status")

    for c in changes:
        old = c["old_version"] or "[dim]<not initialized>[/dim]"
        new = c["new_version"]

        if c["lock"]:
            status = "[blue]🔒 locked[/blue]"
        elif old != new:
            status = "[green]✓ updated[/green]"
        else:
            status = "[dim]unchanged[/dim]"

        table.add_row(c["name"], old, new, status)

    console.print(table)
