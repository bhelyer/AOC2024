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

private func createGrid(dims: Point, toFall: Int,
                        input: [String.SubSequence]) -> Grid {
    return Grid(dimensions: dims, c: ".")
}

private func findShortest(maze: Grid, start: Point, end: Point) -> [Point] {
    return []
}
