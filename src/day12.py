#!/usr/bin/env python3
from sys import stdin

##### PART 1 #####

# Huge troll

def read_shape_area() -> int:
    area = 0
    for _ in range(3):
        for c in input():
            if c == "#":
                area += 1
    stdin.readline()
    return area

def main() -> None:
    line = input()
    shape_areas = []
    while line.endswith(":"):
        shape_areas.append(read_shape_area())
        line = input()
    print("AREAS", shape_areas)

    count = 0
    try:
        while True:
            words = line.split()
            n, m = map(int, words[0].removesuffix(":").split("x"))
            shape_sum = sum(shape_areas[i] * int(words[i+1]) for i in range(len(shape_areas)))
            print(f"{line}: {shape_sum} / {n * m} = {shape_sum / (n * m)}")
            if shape_sum < n * m:
                count += 1
            line = input()
    except EOFError as _:
        pass

    print(count)

if __name__ == "__main__":
    main()
