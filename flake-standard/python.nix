{ pkgs }:
with pkgs; [
  python310
  ruff # Linting + Formatting + Sort Imports (~flake8 + isort + black)
  pyright # Type Checking
  uv
]

