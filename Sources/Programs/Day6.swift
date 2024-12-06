class Day6: Program {
    func run(input: String) throws {
        var grid = try Grid(input)
        var position = grid.findFirst(c: "^")!
        var direction = Point(x: 0, y: -1)
        while markAndMove(&grid, &position, &direction) {
        }
        print("Unique Positions = \(grid.count(c: "X"))")
    }
}

// Mark the current position with an X. Advance the position. Returns true if pos is in bounds.
func markAndMove(_ grid: inout Grid, _ pos: inout Point, _ dir: inout Point) -> Bool {
    grid.set(pos, c: "X")
    pos = pos + dir
    let nextPos = pos + dir
    if grid.get(nextPos) == "#" {
        dir = turnRight(dir)
    }
    return grid.inBounds(pos)
}

func turnRight(_ dir: Point) -> Point {
    if dir == Point(x: 0, y: -1) {
        return Point(x: 1, y: 0)
    } else if dir == Point(x: 1, y: 0) {
        return Point(x: 0, y: 1)
    } else if dir == Point(x: 0, y: 1) {
        return Point(x: -1, y: 0)
    } else {
        return Point(x: 0, y: -1)
    }
}
