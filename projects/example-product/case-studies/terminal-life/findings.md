# Findings

## Keep the example dependency-free

Using only the Python standard library makes the case study runnable on most developer machines and CI images without package installation. This keeps the example focused on harness workflow rather than environment setup.

## Prefer ANSI screen clearing over curses

`curses` is powerful but less portable in simple demos and can complicate automated smoke tests. ANSI clear sequences are enough for this terminal visualization and keep non-interactive runs straightforward.

## Separate simulation from rendering

The simulation core uses sets of live-cell coordinates. Rendering is a separate function. This makes the rules easy to test without relying on terminal output.

## Make checks executable and local

The task includes `repo/scripts/check.sh` so agents have a single command to run before handoff. This mirrors the recommended `scripts/agent/check.sh` pattern used in real repositories.
