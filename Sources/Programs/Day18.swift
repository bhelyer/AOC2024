class Day18: Program {
    func run(input: String) async throws {
        let lines = input.split { $0.isNewline } // Lines of 'x,y'.
        var dims = Point(x: 70, y: 70)           // Size of memory region.
        var toFall = 1024                        // Number of bytes to fall.
        if lines.count < 100 {
            // Sample input, adjust dims and toFall to match.
            dims = Point(x: 6, y: 6)
            toFall = 12
        }
        let grid = createGrid(dims: dims, toFall: toFall, input: lines)
        let path = findShortest(maze: grid, start: Point(), end: dims)
        if path.isEmpty {
            print("No solution!")
        } else {
            print("Shortest path is \(path.count) steps.")
        }
    }
}

/// Return a grid after the bytes have fallen on to it (the maze).
private func createGrid(dims: Point, toFall: Int,
                        input: [String.SubSequence]) -> Grid {
    var grid = Grid(dimensions: dims, c: ".")
    for i in 0..<toFall {
        let p = parsePoint(input[i])
        grid.set(p, c: "#")
    }
    return grid
}

/// Find the shortest path from `start` to `end`, using only `.` tiles.
private func findShortest(maze: Grid, start: Point, end: Point) -> [Point] {
    return []
}

/// Parse a string like `3,-2` into a `Point(x: 3, y: -2)`.
private func parsePoint(_ input: String.SubSequence) -> Point {
    let elements = input.split { $0 == "," }
    let x = Int(String(elements[0]))!
    let y = Int(String(elements[1]))!
    return Point(x: x, y: y)
}
