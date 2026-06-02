"""Utility functions for version handling and git operations."""

import subprocess
import sys
from pathlib import Path
from typing import List, Optional

import semver
from git import Repo

from .constants import console


def validate_git_repo() -> None:
    """Validate that current directory is a valid git repository."""
    if not Path(".git").exists():
        console.print("[red]Not a git repository. Run 'git init' first.[/red]")
        sys.exit(1)
    try:
        Repo(".")
    except Exception as e:
        console.print(f"[red]Git repository error: {e}[/red]")
        sys.exit(1)


def is_valid_semver(version: str) -> bool:
    """Check if a version string is valid semver."""
    try:
        semver.VersionInfo.parse(version)
        return True
    except (ValueError, TypeError):
        return False


def parse_semver_safe(version: str) -> Optional[semver.VersionInfo]:
    """Safely parse a semver version string."""
    try:
        return semver.VersionInfo.parse(version)
    except (ValueError, TypeError):
        return None


def get_latest_git_tags(repo_url: str) -> List[str]:
    """Fetch all tags from a remote git repository."""
    try:
        result = subprocess.run(
            ["git", "ls-remote", "--tags", repo_url],
            capture_output=True,
            text=True,
            check=True,
            timeout=30
        )
    except subprocess.TimeoutExpired:
        raise RuntimeError(f"Timeout while fetching tags from {repo_url}")
    except subprocess.CalledProcessError as e:
        error_msg = e.stderr.strip() if e.stderr else str(e)
        raise RuntimeError(f"Failed to fetch tags: {error_msg}")

    tags = []
    for line in result.stdout.splitlines():
        if "refs/tags/" in line and "^{}" not in line:
            tag = line.split("refs/tags/")[1]
            tags.append(tag)

    # Sort only valid semver tags; non-semver tags are appended at the end
    semver_tags = [t for t in tags if is_valid_semver(t)]
    non_semver_tags = [t for t in tags if not is_valid_semver(t)]
    sorted_semver = sorted(semver_tags, key=lambda t: semver.VersionInfo.parse(t))
    return non_semver_tags + sorted_semver


def get_local_version(module_name: str) -> Optional[str]:
    """Returns the version from the lock file for the given module name."""
    from .lock import get_locked_version
    return get_locked_version(module_name)


def calculate_version_bump(old_version: str, new_version: str) -> Optional[str]:
    """Calculate the type of version bump (major, minor, patch) or None."""
    old = parse_semver_safe(old_version)
    new = parse_semver_safe(new_version)

    if not old or not new:
        return None

    if new.major > old.major:
        return "major"
    elif new.minor > old.minor:
        return "minor"
    elif new.patch > old.patch:
        return "patch"
    return None
