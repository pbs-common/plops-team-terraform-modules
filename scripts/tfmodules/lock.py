"""Lock file management (modules.lock)."""

import yaml
from pathlib import Path
from typing import Dict, Optional
from datetime import datetime

from .constants import LOCK_FILE, console


def load_lock_file() -> Dict:
    """Load the modules lock file."""
    try:
        if not Path(LOCK_FILE).exists():
            return {"modules": {}}
        with open(LOCK_FILE) as f:
            lock_data = yaml.safe_load(f)
            if lock_data is None:
                return {"modules": {}}
            return lock_data
    except yaml.YAMLError as e:
        console.print(f"[red]YAML parsing error in '{LOCK_FILE}': {e}[/red]")
        return {"modules": {}}
    except Exception as e:
        console.print(f"[yellow]Warning: Could not load lock file: {e}[/yellow]")
        return {"modules": {}}


def save_lock_file(lock_data: Dict) -> None:
    """Save the modules lock file."""
    try:
        with open(LOCK_FILE, "w") as f:
            yaml.dump(lock_data, f, sort_keys=False, default_flow_style=False)
    except Exception as e:
        console.print(f"[yellow]Warning: Could not save lock file: {e}[/yellow]")


def update_lock_file(module_name: str, version: str, source: str) -> None:
    """Update lock file with module version information."""
    lock_data = load_lock_file()
    if "modules" not in lock_data:
        lock_data["modules"] = {}

    lock_data["modules"][module_name] = {
        "version": version,
        "source": source,
        "updated_at": datetime.now().isoformat()
    }
    save_lock_file(lock_data)


def get_locked_version(module_name: str) -> Optional[str]:
    """Get the locked version for a module."""
    lock_data = load_lock_file()
    if "modules" in lock_data and module_name in lock_data["modules"]:
        return lock_data["modules"][module_name].get("version")
    return None


def remove_from_lock_file(module_name: str) -> None:
    """Remove a module from the lock file."""
    lock_data = load_lock_file()
    if "modules" in lock_data and module_name in lock_data["modules"]:
        del lock_data["modules"][module_name]
        save_lock_file(lock_data)
