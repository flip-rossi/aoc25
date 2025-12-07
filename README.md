# Advent of Code 2025 solutions

These are my solutions for the [2025 edition](https://adventofcode.com/2025) of the annual event **Advent of Code**.

- The code for each solution is in [src/main/](src/main/), in either Java, Rust, C++, OCaml, or Tcl.


## Helper scripts

There are three helper scripts to prepare solutions, test, and submit answers:  
- [setup_day.sh](setup_day.sh)  
  Creates a new source code file in [src/main/](src/main/) from one of the templates in templates/
  and downloads the day's input to inputs/.
- [submit_answer.sh](submit_answer.sh)  
  Submits the answer for the day and selected puzzle part.
  If no answer is passed as argument, reads from clipboard.
- [run.sh](run.sh)  
  Compiles and runs the solution in any language for the specified day (or today,
  if none is specified).

They both need you to have a .env file in the root of the project with a line like this: `SESSION_TOKEN=yoursessiontoken`  
You can get your session token by looking at your cookies when logged on in the [AoC website](https://adventofcode.com/auth/login).

**Don't let anyone have access to your session token.**


## Solutions

> - lang - part 1 done in language;
> - **lang** - parts 1 and 2 done in language.

| Day                                                                    |  Languages                          |
|------------------------------------------------------------------------|-------------------------------------|
| [Day 1: Secret Entrance](https://adventofcode.com/2025/day/1)          | **[OCaml](./src/main/ml/day01.ml)** |
| [Day 2: Gift Shop](https://adventofcode.com/2025/day/2)                | **[Tcl](./src/main/tcl/day02.tcl)**  |
| [Day 3: Lobby](https://adventofcode.com/2025/day/3)                | **[Tcl](./src/main/tcl/day03.tcl)**  |
| [Day 4: Printing Department](https://adventofcode.com/2025/day/4)                | **[Tcl](./src/main/tcl/day04.tcl)**  |


# Previous years

- [2024](https://github.com/flip-rossi/aoc24)
- [2023](https://github.com/flip-rossi/aoc23)
- [2022](https://github.com/flip-rossi/aoc22)

