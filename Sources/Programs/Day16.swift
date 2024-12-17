class Day16: Program {
    func run(input: String) async throws {
        let grid = try Grid(input)
        if let score = lowestScore(maze: grid) {
            print("Day 16 part 1 = \(score)")
        } else {
            print("Day 16 part 1 = no solution!")
        }
    }
}

private func lowestScore(maze: Grid) -> Int? {
    guard let startPos = maze.findFirst(c: "S") else {
        return nil
    }
    guard let endPos = maze.findFirst(c: "E") else {
        return nil
    }
    let solution = findShortestPath(maze: maze, start: startPos, goal: endPos)
    let path = constructPath(fromSolution: solution, start: startPos, target: endPos)
    var grid = maze
    for point in path[1..<path.count-1] {
        grid.set(point, c: "X")
    }
    print(grid)
    
    return cost(solution: solution, start: startPos, target: endPos)
}

private struct Graph {
    var vertices: [Point]
}

private struct Solution {
    var dist: [Point: Double] = [:]
    var prev: [Point: Point] = [:]
    var dir: [Point: Point] = [:]
}

private func findShortestPath(maze: Grid, start: Point, goal: Point) -> Solution {
    var solution = Solution()
    let vertices = getPoints(from: maze)
    var q: [Point] = []
    for v in vertices {
        solution.dist[v] = Double.infinity
        solution.prev[v] = nil
        q.append(v)
    }
    solution.dist[start] = 0
    solution.dir[start] = Point(x: 1, y: 0)
    
    while !q.isEmpty {
        q.sort { solution.dist[$0, default: Double.infinity] > solution.dist[$1, default: Double.infinity] }
        let u = q.popLast()!
        let prevDir = solution.dir[u]!
        
        for v in getNeighbours(maze: maze, point: u).filter({ q.contains($0) }) {
            let (moveCost, nextDir) = getMoveCost(prevDir: prevDir, a: u, b: v)
            let alt = solution.dist[u]! + moveCost
            if alt < solution.dist[v]! {
                solution.dist[v] = alt
                solution.prev[v] = u
                solution.dir[v] = nextDir
            }
        }
    }
    
    return solution
}

func getMoveCost(prevDir: Point, a: Point, b: Point) -> (Double, Point)
{
    if a + prevDir == b {
        return (1.0, prevDir)
    } else if a + rotateLeft(prevDir) == b {
        return (1001.0, rotateLeft(prevDir))
    } else if a + rotateRight(prevDir) == b {
        return (1001.0, rotateRight(prevDir))
    } else {
        return (2002.0, rotateRight(rotateRight(prevDir)))
    }
}

func getNeighbours(maze: Grid, point: Point) -> [Point] {
    var neighbours: [Point] = []
    for dir in upDownLeftRight {
        let p = point + dir
        let c = maze.get(p)
        if c != "#" && c != " " {
            neighbours.append(p)
        }
    }
    return neighbours
}

private func getPoints(from maze: Grid) -> [Point] {
    var points: [Point] = []
    for y in 0..<maze.height {
        for x in 0..<maze.width {
            let p = Point(x: x, y: y)
            let c = maze.get(p)
            if c != "#" {
                points.append(p)
            }
        }
    }
    return points
}

private func cost(solution: Solution, start: Point, target: Point) -> Int {
    let path = constructPath(fromSolution: solution, start: start, target: target)
    return cost(path: path)
}

private func constructPath(fromSolution solution: Solution, start: Point, target: Point) -> [Point] {
    var path: [Point] = []
    var u: Point? = target
    let prev = solution.prev[target]
    if prev != nil || u == start {
        while u != nil {
            path.append(u!)
            u = solution.prev[u!]
        }
    }
    return path.reversed()
}

private func cost(path: [Point]) -> Int {
    guard !path.isEmpty else {
        return 0
    }
    var currentDir = upDownLeftRight[3]
    var currentPos = path.first!
    var currentCost = 0
    for i in 1..<path.count {
        let nextPos = path[i]
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
