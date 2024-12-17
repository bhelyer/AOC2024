class Day16: Program {
    func run(input: String) async throws {
        let grid = try Grid(input)
        print("Day 16 part 1 = \(lowestScore(maze: grid)!)")
    }
}

private enum Move {
    case moveForward
    case rotateLeft
    case rotateRight
}

private func lowestScore(maze: Grid) -> Int? {
    guard let startPos = maze.findFirst(c: "S") else {
        return nil
    }
    guard let _ = maze.findFirst(c: "E") else {
        return nil
    }
    
    var solutions = findSolutions(maze: maze, start: startPos)
    //print(solutions)
    /*
    for solution in solutions {
        print("cost = \(cost(solution: solution))")
        var grid = maze
        for point in solution[1..<solution.count-1] {
            grid.set(point, c: "X")
        }
        print(grid)
    }
     */
    var costs = solutions.map { cost(solution: $0) }
    return costs.min()!
}

private func findSolutions(maze: Grid, start: Point) -> [[Point]] {
    var solutions: [[Point]] = []
    var path = [start]
    recursiveSolve(maze: maze, path: path, solutions: &solutions)
    return solutions
}

func recursiveSolve(maze: Grid, path: [Point], solutions: inout [[Point]]) {
    var path = path
    guard !path.isEmpty else {
        return
    }
    if maze.get(path.last!) == "E" {
        solutions.append(path)
        return
    }
    var openPoints = findOpenPoints(maze: maze, path: path)
    if openPoints.isEmpty {
        return
    }
    while openPoints.count == 1 {
        path.append(openPoints.first!)
        if maze.get(path.last!) == "E" {
            solutions.append(path)
            return
        }
        openPoints = findOpenPoints(maze: maze, path: path)
    }
    if openPoints.isEmpty {
        return
    }
    for openPoint in openPoints {
        var fork = path
        fork.append(openPoint)
        recursiveSolve(maze: maze, path: fork, solutions: &solutions)
    }
}

private func findOpenPoints(maze: Grid, path: [Point]) -> [Point] {
    if path.isEmpty {
        return []
    }
    var openPaths: [Point] = []
    for dir in upDownLeftRight {
        let p = path.last! + dir
        if !path.contains(p) && maze.get(p) != "#" {
            openPaths.append(p)
        }
    }
    return openPaths
}

private func cost(solution: [Point]) -> Int {
    guard !solution.isEmpty else {
        return 0
    }
    var currentDir = upDownLeftRight[3]
    var currentPos = solution.first!
    var currentCost = 0
    for i in 1..<solution.count {
        var nextPos = solution[i]
        if currentPos + currentDir == nextPos {
            currentCost += 1
            currentPos = nextPos
        } else if currentPos + rotateLeft(currentDir) == nextPos {
            currentCost += 1001 // 1001 = rotate + move
            currentPos = nextPos
            currentDir = rotateLeft(currentDir)
        } else if currentPos + rotateRight(currentDir) == nextPos {
            currentCost += 1001 // 1001 = rotate + move
            currentPos = nextPos
            currentDir = rotateRight(currentDir)
        } else {
            // we don't consider backtracking as open squares,
            // so no solution should require us to spin right round
            print("? pos=\(currentPos) next=\(nextPos) dir=\(currentDir)")
            return 0
        }
    }
    return currentCost
}

func rotateLeft(_ p: Point) -> Point {
    switch p {
    case Point(x: 0, y: -1): return Point(x: -1, y: 0)
    case Point(x: 1, y: 0): return Point(x: 0, y: -1)
    case Point(x: 0, y: 1): return Point(x: 1, y: 0)
    case Point(x: -1, y: 0): return Point(x: 0, y: 1)
    default: return p
    }
}

func rotateRight(_ p: Point) -> Point {
    switch p {
    case Point(x: 0, y: -1): return Point(x: 1, y: 0)
    case Point(x: 1, y: 0): return Point(x: 0, y: 1)
    case Point(x: 0, y: 1): return Point(x: -1, y: 0)
    case Point(x: -1, y: 0): return Point(x: 0, y: -1)
    default: return p
    }
}
