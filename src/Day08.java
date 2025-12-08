import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.tuple.Triple;

import lib.java.Point3D;
import lib.java.UnionFind;

/**
 * <h1>Day 8 - Playground</h1>
 * https://adventofcode.com/2025/day/8
 * <p>
 * Start:  2025-12-08 11:48 <br>
 * Finish: 2025-12-08 14:00, 14:15
 */
public class Day08 {
    static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

    public static void main(String[] args) throws IOException {
        // Parse input
        var points = in.lines()
                .map(line -> Point3D.ofSplit(line, ","))
                .toList();

        // Solve
        if (args.length < 1) {
            System.err.println("Please specify the part to solve.");
            System.exit(1);
        }
        int part = Integer.parseInt(args[0]);
        switch (part) {
            case 1 -> System.out.println(part1(points));
            case 2 -> System.out.println(part2(points));
            default -> {
                System.err.println("Part must be 1 or 2.");
                System.exit(1);
            }
        }
    }

    // =============== PART 1 ===============//
    static long part1(List<Point3D> points) {
        int nConnections = points.size() == 1000 ? 1000 : 10;

        // max heap
        @SuppressWarnings("unchecked")
        Triple<Integer, Integer, Long>[] distances = new Triple[nConnections];
        int size = 0;
        for (int i = 0; i < points.size() - 1; i++) {
            for (int j = i + 1; j < points.size(); j++) {
                var dist = points.get(i).distanceSq(points.get(j));
                if (size < nConnections) {
                    // Insert and sift up
                    var idx = size++;
                    var item = Triple.of(i, j, dist);
                    distances[idx] = item;
                    while (idx > 0) {
                        int parentIdx = (idx - 1) / 2;
                        var parentItem = distances[parentIdx];
                        if (dist < parentItem.getRight()) {
                            break;
                        }
                        distances[parentIdx] = item;
                        distances[idx] = parentItem;
                        idx = parentIdx;
                    }
                } else if (dist < distances[0].getRight()) {
                    // Swap with max, sifting down
                    var item = Triple.of(i, j, dist);
                    var idx = 0;
                    distances[0] = item;
                    for (int left = idx * 2 + 1; left < size; left = idx * 2 + 1) {
                        var right = idx * 2 + 2;
                        var swapIdx = right >= size || distances[left].getRight() > distances[right].getRight()
                                ? left
                                : right;
                        if (dist > distances[swapIdx].getRight()) {
                            break;
                        }
                        distances[idx] = distances[swapIdx];
                        distances[swapIdx] = item;
                        idx = swapIdx;
                    }
                }
            }
        }

        Arrays.sort(distances, (x, y) -> x.getRight() < y.getRight() ? -1 : 1);

        var uf = new UnionFind(points.size());
        var setSizes = new int[points.size()];
        for (int i = 0; i < setSizes.length; i++) {
            setSizes[i] = 1;
        }

        for (var e : distances) {
            var a = e.getLeft();
            var b = e.getMiddle();
            if (!uf.sameSet(a, b)) {
                int aSize = setSizes[uf.find(a)];
                int bSize = setSizes[uf.find(b)];
                setSizes[uf.union(a, b)] = aSize + bSize;
            }
        }

        int[] top3 = new int[4];
        for (int i = 0; i < uf.size(); i++) {
            if (uf.isRepresentative(i)) {
                int val = setSizes[i];
                for (int j = 2; j >= 0; j--) {
                    if (val > top3[j]) {
                        top3[j + 1] = top3[j];
                        top3[j] = val;
                    } else {
                        break;
                    }
                }
            }
        }
        return top3[0] * top3[1] * top3[2];
    }

    // =============== PART 2 ===============//
    static long part2(List<Point3D> points) {
        @SuppressWarnings("unchecked")
        Triple<Integer, Integer, Long>[] distances = new Triple[(points.size() * points.size() - points.size()) / 2];
        int size = 0;
        for (int i = 0; i < points.size() - 1; i++) {
            for (int j = i + 1; j < points.size(); j++) {
                var dist = points.get(i).distanceSq(points.get(j));
                distances[size++] = Triple.of(i, j, dist);
            }
        }

        Arrays.sort(distances, (x, y) -> x.getRight() < y.getRight() ? -1 : 1);

        var uf = new UnionFind(points.size());
        for (var e : distances) {
            var a = e.getLeft();
            var b = e.getMiddle();
            uf.union(a, b);
            if (uf.distinctSets() == 1) {
                return points.get(a).x * points.get(b).x;
            }
        }

        throw new AssertionError();
    }

}
