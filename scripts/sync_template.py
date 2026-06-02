#!/usr/bin/env python3
"""Sync tooling files from the terraform-modules-template repository.

Run this script from a repository that was created from the template to pull
the latest scripts, workflows, and tooling files while preserving all
repository-specific files (config, modules, README, etc.).

Usage:
    python scripts/sync_template.py
"""

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from rich.console import Console
from rich.table import Table
from rich.panel import Panel

console = Console()

TEMPLATE_URL = "git@github.com:pbs-common/terraform-modules-template"

# Files/dirs that belong to the downstream repo and must never be overwritten.
PROTECTED = {
    "config.yaml",
    "modules",
    "modules.lock",
    "README.md",
    ".git",
    "venv",
}


def clone_template(dest: Path) -> None:
    """Clone the template at the main branch."""
    console.print(f"[dim]Cloning {TEMPLATE_URL} ...[/dim]")
    subprocess.run(
        ["git", "clone", "--quiet", "--branch", "main", "--depth", "1", TEMPLATE_URL, str(dest)],
        check=True,
        capture_output=True,
    )


def collect_template_files(template_root: Path) -> list[Path]:
    """Return all relative file paths from the template that are eligible for syncing."""
    files = []
    for item in template_root.rglob("*"):
        rel = item.relative_to(template_root)
        if rel.parts[0] in PROTECTED:
            continue
        if item.is_file():
            files.append(rel)
    return sorted(files)


def file_differs(src: Path, dst: Path) -> bool:
    """Return True if src and dst differ or dst doesn't exist."""
    if not dst.exists():
        return True
    return src.read_bytes() != dst.read_bytes()


def sync_files(template_root: Path, target_root: Path) -> tuple[list[Path], list[Path]]:
    """Copy changed files from template to target. Returns (added, updated)."""
    added: list[Path] = []
    updated: list[Path] = []

    for rel in collect_template_files(template_root):
        src = template_root / rel
        dst = target_root / rel

        if not file_differs(src, dst):
            continue

        if dst.exists():
            updated.append(rel)
        else:
            added.append(rel)

        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)

    return added, updated


def print_summary(ref: str, added: list[Path], updated: list[Path]) -> None:
    """Print a rich summary table of synced changes."""
    console.print()

    if not added and not updated:
        console.print(
            Panel(
                f"Already up to date with template [cyan]{ref}[/cyan].",
                border_style="green",
            )
        )
        return

    table = Table(title=f"Template sync — [cyan]{ref}[/cyan]")
    table.add_column("Status", style="bold", width=10)
    table.add_column("File")

    for f in added:
        table.add_row("[green]added[/green]", str(f))
    for f in updated:
        table.add_row("[cyan]updated[/cyan]", str(f))

    console.print(table)
    console.print(f"\n[green]✓[/green] {len(added)} added, {len(updated)} updated")


def main() -> None:
    """Sync tooling files from the terraform-modules-template repository."""
    target_root = Path.cwd()

    if not (target_root / ".git").exists():
        console.print("[red]Not a git repository. Run from the root of your repo.[/red]")
        sys.exit(1)

    with tempfile.TemporaryDirectory() as tmp:
        template_root = Path(tmp) / "template"
        try:
            clone_template(template_root)
        except subprocess.CalledProcessError as e:
            err = e.stderr.decode().strip() if e.stderr else str(e)
            console.print(f"[red]Failed to clone template: {err}[/red]")
            sys.exit(1)

        console.print("[dim]Syncing from template [cyan]main[/cyan]...[/dim]")
        added, updated = sync_files(template_root, target_root)

    print_summary("main", added, updated)


if __name__ == "__main__":
    main()
