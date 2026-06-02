"""Configuration file management (config.yaml)."""

import sys
import yaml
from typing import Dict

from .constants import CONFIG_FILE, console


def load_config() -> Dict:
    """Load and parse the configuration file."""
    try:
        with open(CONFIG_FILE) as f:
            config = yaml.safe_load(f)
            if config is None:
                return {"modules": []}
            # Ensure modules is a list, not None
            if config.get("modules") is None:
                config["modules"] = []
            return config
    except FileNotFoundError:
        console.print(f"[red]Config file '{CONFIG_FILE}' not found[/red]")
        sys.exit(1)
    except yaml.YAMLError as e:
        console.print(f"[red]YAML parsing error in '{CONFIG_FILE}': {e}[/red]")
        sys.exit(1)


def save_config(config: Dict) -> None:
    """Save configuration to file."""
    try:
        with open(CONFIG_FILE, "w") as f:
            yaml.dump(config, f, sort_keys=False, default_flow_style=False)
    except Exception as e:
        console.print(f"[red]Failed to save config: {e}[/red]")
        sys.exit(1)
