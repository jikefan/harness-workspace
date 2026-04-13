# Terminal Life

A tiny, zero-dependency Python implementation of Conway's Game of Life for terminal demos and harness workflow examples.

## Usage

```bash
python3 life.py --seed glider --width 40 --height 18 --steps 80 --fps 12
```

Useful options:

```bash
python3 life.py --help
python3 life.py --seed blinker --steps 20
python3 life.py --seed random --width 60 --height 24 --density 0.25 --steps 120
python3 life.py --seed block --steps 3 --fps 0 --no-clear
```

## Checks

```bash
./scripts/check.sh
```

## Implementation notes

- The board is represented as a set of live `(x, y)` coordinates.
- The simulation core is independent from terminal rendering.
- Edge wrapping is enabled by default and can be disabled with `--no-wrap`.
- The project intentionally uses only the Python standard library.
