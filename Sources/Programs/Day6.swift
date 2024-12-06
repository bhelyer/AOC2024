class Day6: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        var grid = try Grid(input)
        var position = grid.findFirst(c: "^")!
        var direction = Point(x: 0, y: -1)
        while markAndMove(&grid, &position, &direction) {
        }
        print("Unique Positions = \(grid.count(c: "X"))")
    }
    
    func part2(input: String) throws {
        let startingGrid = try Grid(input)
        let startingPosition = startingGrid.findFirst(c: "^")!
        let startingDirection = Point(x: 0, y: -1)
        
        var loopingObstacles = 0
        for y in 0..<startingGrid.height {
            for x in 0..<startingGrid.width {
                let obstaclePoint = Point(x: x, y: y)
                if startingGrid.get(obstaclePoint) != "." {
                    continue
                }
                var grid = startingGrid
                grid.set(obstaclePoint, c: "O")
                var pos = startingPosition
                var dir = startingDirection
                if isLoop(&grid, &pos, &dir) {
                    loopingObstacles += 1
                }
            }
        }
        print("Looping Obstacles = \(loopingObstacles)")
    }
}

struct PointGrid {
    let height: Int
    let width: Int
    var grid: [[Point?]]
    
    init(fromGrid grid: Grid) {
        self.height = grid.height
        self.width = grid.width
        self.grid = [[Point?]](repeating: [Point?](repeating: nil, count: width), count: height)
    }
    
    func get(_ p: Point) -> Point? {
        guard p.x >= 0 && p.x < width && p.y >= 0 && p.y < height else {
            return nil
        }
        return grid[p.y][p.x]
    }
    
    mutating func set(point p: Point, to: Point) {
        if p.x >= 0 && p.x < width && p.y >= 0 && p.y < height {
            grid[p.y][p.x] = to
        }
    }
}

func isLoop(_ grid: inout Grid, _ pos: inout Point, _ dir: inout Point) -> Bool {
    var pointGrid = PointGrid(fromGrid: grid)
    repeat {
        let inFront = pos + dir
        if grid.get(inFront) == "#" || grid.get(inFront) == "O" {
            dir = turnRight(dir)
        } else {
            pos = pos + dir
            if let oldDir = pointGrid.get(pos) {
                if grid.inBounds(pos) && oldDir == dir {
                    return true
                }
            }
            pointGrid.set(point: pos, to: dir)
        }
    } while grid.inBounds(pos)
    return false
}

// Mark the current position with an X. Advance the position. Returns true if pos is in bounds.
func markAndMove(_ grid: inout Grid, _ pos: inout Point, _ dir: inout Point) -> Bool {
    grid.set(pos, c: "X")
    pos = pos + dir
    let nextPos = pos + dir
    if grid.get(nextPos) == "#" || grid.get(nextPos) == "O" {
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
