"""README.md generation and management."""

import sys
from pathlib import Path
from typing import Dict, Tuple

from .constants import (
    README_FILE,
    README_MODULES_SECTION,
    README_START_MARKER,
    README_END_MARKER,
    README_GENERATED_COMMENT,
    console,
)


def find_readme_section(content: str) -> Tuple[int, int, int]:
    """
    Find the modules section in README.
    Returns: (section_start, marker_start, marker_end) indices or (-1, -1, -1) if not found.
    """
    section_start = content.find(README_MODULES_SECTION)
    if section_start == -1:
        return (-1, -1, -1)

    marker_start = content.find(README_START_MARKER, section_start)
    if marker_start == -1:
        return (-1, -1, -1)

    marker_end = content.find(README_END_MARKER, marker_start)
    if marker_end == -1:
        return (-1, -1, -1)

    return (section_start, marker_start, marker_end)


def generate_modules_section(config: Dict) -> str:
    """Generate the modules section content for README."""
    if not config.get("modules"):
        return f"{README_MODULES_SECTION}\n\n{README_GENERATED_COMMENT}\n\n_No modules are currently defined in this repository._\n"

    lines = [f"{README_MODULES_SECTION}\n", README_GENERATED_COMMENT, "\n"]
    for m in config["modules"]:
        lines.append(f"- **{m['name']}** `{m['version']}`  \n  Source: `{m['source']}`\n")

    return "".join(lines)


def generate_readme(config: Dict) -> None:
    """Generate or update README.md with module information."""
    try:
        readme_path = Path(README_FILE)
        content = readme_path.read_text() if readme_path.exists() else ""

        section_start, marker_start, marker_end = find_readme_section(content)
        modules_section = generate_modules_section(config)

        if section_start == -1:
            # Append at end
            new_content = content.rstrip() + "\n\n" + modules_section
        else:
            # Replace existing section
            new_content = content[:section_start] + modules_section + content[marker_end + len(README_END_MARKER):]

        readme_path.write_text(new_content)
        console.print(f"[green]✓ {README_FILE} updated[/green]")
    except Exception as e:
        console.print(f"[red]Failed to generate {README_FILE}: {e}[/red]")
        sys.exit(1)
