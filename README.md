# Advent of Code 2025 solutions

These are my solutions for the [2025 edition](https://adventofcode.com/2025) of the annual event **Advent of Code**.
Each solution is in [src/](src/), in either Java, Rust, C++, OCaml, or Tcl.


## Helper scripts

- [setup_day.sh](setup_day.sh)[^.env]  
  Creates a new source code file in [src/](src/) from one of the templates in templates/
  and downloads the day's input to inputs/.
- [submit_answer.sh](submit_answer.sh)[^.env]  
  Submits the answer for the day and selected puzzle part.
  If no answer is passed as argument, reads from clipboard.
- [run.sh](run.sh)  
  Compiles and runs the solution in any language for the specified day (or today,
  if none is specified).

[^.env]: You need to set the `SESSION_TOKEN` environment variable. You can do so by creating a .env file. You can get your AoC session token from your cookies after logging in.


## Solutions

> ☆ - part 1 done; ★ - parts 1 and 2 done.

| Day                                                               | Solution                   |
|-------------------------------------------------------------------|----------------------------|
| [Day 1: Secret Entrance](https://adventofcode.com/2025/day/1)     | [★ OCaml](./src/day01.ml)  |
| [Day 2: Gift Shop](https://adventofcode.com/2025/day/2)           | [★ Tcl](./src/day02.tcl)   |
| [Day 3: Lobby](https://adventofcode.com/2025/day/3)               | [★ Tcl](./src/day03.tcl)   |
| [Day 4: Printing Department](https://adventofcode.com/2025/day/4) | [★ Tcl](./src/day04.tcl)   |
| [Day 5: Cafeteria](https://adventofcode.com/2025/day/5)           | [★ OCaml](./src/day05.ml)  |
| [Day 6: Trash Compactor](https://adventofcode.com/2025/day/6)     | [★ OCaml](./src/day06.ml)  |
| [Day 7: Laboratories](https://adventofcode.com/2025/day/7)        | [★ OCaml](./src/day07.ml)  |
| [Day 8: Playground](https://adventofcode.com/2025/day/8)          | [★ Java](./src/Day08.java) |
| [Day 9: Movie Theater](https://adventofcode.com/2025/day/9)       | [★ OCaml](./src/day09.ml)  |



# Previous years

- [2024](https://github.com/flip-rossi/aoc24)
- [2023](https://github.com/flip-rossi/aoc23)
- [2022](https://github.com/flip-rossi/aoc22)

