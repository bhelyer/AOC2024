class Day20: Program {
    func run(input: String) async throws {
        //-- Parse input.
        var _grid = try Grid(input)
        guard let start = _grid.findFirst(c: "S") else { return }
        guard let end = _grid.findFirst(c: "E") else { return }
        _grid.set(start, c: ".")
        _grid.set(end, c: ".")
        let grid = _grid
        
        //-- Find shortest path, and its time.
        let graph = Graph(from: grid)
        let (_, prev) = dijkstra(graph, source: start)
        let path = sequence(prev: prev, source: start, target: end)
        print("Base path time is \(path.count - 1) picoseconds")
        
        //-- Find all the adjacent walls.
        let pathAdjacentWalls = findAdjacentWalls(grid: grid, path: path)
        var adjacentGrid = grid
        for wall in pathAdjacentWalls {
            adjacentGrid.set(wall, c: "X")
        }
        print(adjacentGrid)
        
        //-- Look for all the cheats.
        // Picoseconds Saved: Number Of Cheats
        var savings = [Int: Int]()
        for wall in pathAdjacentWalls {
            var cheatPrev = prev
            var pathPointIndex: Int? = nil
            var otherPoints = [Vertex]()
            for dir in upDownLeftRight {
                let p = wall + dir
                if let i = path.firstIndex(of: p) {
                    if i < pathPointIndex ?? Int.max {
                        if pathPointIndex != nil {
                            otherPoints.append(Vertex(fromPoint: path[pathPointIndex!]))
                        }
                        pathPointIndex = i
                        continue
                    }
                }
                if grid.get(p) == "."  {
                    otherPoints.append(Vertex(fromPoint: p))
                }
            }
            guard let pathPointIndex else {
                continue
            }
            let wallVertex = Vertex(fromPoint: wall)
            cheatPrev[wallVertex] = Vertex(fromPoint: path[pathPointIndex])
            for otherPoint in otherPoints {
                cheatPrev[otherPoint] = wallVertex
            }
            
            //var cheatGrid = grid
            //cheatGrid.set(wall, c: ".")
            //let cheatGraph = Graph(from: cheatGrid)
            //let (_, cheatPrev) = dijkstra(cheatGraph, source: start)
            let cheatPath = sequence(prev: cheatPrev, source: start, target: end)
            if cheatPath.count != path.count {
                savings[path.count - cheatPath.count, default: 0] += 1
            }
        }

        var bigSavings = 0
        for (savings, noOfCheats) in savings {
            print("Cheats saving \(savings) picoseconds: \(noOfCheats)")
            if (savings >= 100) {
                bigSavings += noOfCheats
            }
        }
        print("Cheats saving you more than 100 picoseconds: \(bigSavings)")
    }
}

/// Find the shortest path from `start` to `end`, using only `.` tiles.
private func findShortest(maze: Grid, start: Point, end: Point) async -> [Point] {
    let graph = Graph(from: maze)
    let (_, prev) = dijkstra(graph, source: start)
    return sequence(prev: prev, source: start, target: end)
}

private class Graph {
    var grid: Grid
    var vertices: [Vertex]
    
    init(from maze: Grid) {
        self.grid = maze
        var vertices: [Vertex] = []
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                let p = Point(x: x, y: y)
                if grid.get(p) == "." {
                    vertices.append(Vertex(fromPoint: p))
                }
            }
        }
        self.vertices = vertices
    }
}

private class Vertex: Hashable {
    var point: Point
    
    init(fromPoint point: Point) {
        self.point = point
    }
    
    static func ==(_ lhs: Vertex, _ rhs: Vertex) -> Bool {
        return lhs.point == rhs.point
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
}

private typealias Dist = [Vertex: Double]
private typealias Prev = [Vertex: Vertex?]

private func dijkstra(_ graph: Graph, source: Point) -> (Dist, Prev) {
    var dist: Dist = [:]
    var prev: Prev = [:]
    var q: [Vertex] = []
    
    for v in graph.vertices {
        dist[v] = Double.infinity
        prev[v] = nil
        q.append(v)
    }
    dist[Vertex(fromPoint: source)] = 0
    
    let d = { (v: Vertex) in
        return dist[v, default: Double.infinity]
    }
    while !q.isEmpty {
        q.sort { d($0) > d($1) }
        let u = q.popLast()!
        let adjacent = neighbours(of: u, in: graph)
        for v in adjacent.filter({ q.contains($0) }) {
            let alt = dist[u]! + 1
            if alt < dist[v, default: Double.infinity] {
                dist[v] = alt
                prev[v] = u
            }
        }
    }
    return (dist, prev)
}

private func sequence(prev: Prev, source: Point, target: Point) -> [Point] {
    var path: [Point] = []
    var u: Vertex? = Vertex(fromPoint: target)
    if prev[u!] != nil || u!.point == source {
        while u != nil {
            path.append(u!.point)
            u = prev[u!, default: nil]
        }
    }
    return path.reversed()
}

private func neighbours(of v: Vertex, in graph: Graph) -> [Vertex] {
    var vertices: [Vertex] = []
    for dir in upDownLeftRight {
        let p = v.point + dir
        if graph.grid.get(p) == "." {
            vertices.append(Vertex(fromPoint: p))
        }
    }
    return vertices
}

// Find the set of wall tiles that removing may result in a faster time.
private func findAdjacentWalls(grid: Grid, path: [Point]) -> [Point] {
    var walls = [Point]()
    for point in path {
        let pointDist = distance(point, path.last!)
        for dir in upDownLeftRight {
            let maybeWall = point + dir
            let maybeWallDist = distance(maybeWall, path.last!)
            // If:
            //   - The tile we would remove is a wall, and
            //   - We haven't already seen this wall, and
            //   - This wall is closer to the destination than the original point, and
            //   - There's a floor tile connected to it that isn't the original point
            // Then: Add it to the result set.
            if grid.get(maybeWall) == "#" && !walls.contains(maybeWall) &&
                maybeWallDist < pointDist && countAdjacentWalls(grid: grid, point: maybeWall) <= 2  {
                walls.append(maybeWall)
            }
        }
    }
    return walls
}

private func countAdjacentWalls(grid: Grid, point: Point) -> Int {
    var sum = 0
    for dir in upDownLeftRight {
        if (grid.get(dir + point) == "#") {
            sum += 1
        }
    }
    return sum
}

func distance(_ a: Point, _ b: Point) -> Double {
    let ax = Double(a.x)
    let ay = Double(a.y)
    let bx = Double(b.x)
    let by = Double(b.y)
    let dx = bx - ax
    let dy = by - ay
    return (dx * dx + dy * dy).squareRoot()
}
