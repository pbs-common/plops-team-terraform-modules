#!/usr/bin/env python3
"""Terraform modules management tool - entrypoint.

This script serves as a thin entrypoint that imports and runs the CLI
from the tfmodules package. All logic is implemented in the tfmodules/ package.
"""

import sys

from tfmodules.cli import cli

if __name__ == "__main__":
    try:
        cli()
    except KeyboardInterrupt:
        print("\nInterrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
