class Day18: Program {
    func run(input: String) async throws {
        let lines = input.split { $0.isNewline } // Lines of 'x,y'.
        var dims = Point(x: 71, y: 71)           // Size of memory region.
        var toFall = 1024                        // Number of bytes to fall.
        if lines.count < 100 {
            // Sample input, adjust dims and toFall to match.
            dims = Point(x: 7, y: 7)
            toFall = 12
        }
        while true {
            let grid = createGrid(dims: dims, toFall: toFall, input: lines)
            let end = dims - Point(x: 1, y: 1)
            let path = findShortest(maze: grid, start: Point(), end: end)
            if path.isEmpty {
                print("No solution!")
                print(lines[toFall - 1])
                print(grid)
                return
            } else {
                var solvedGrid = grid
                for p in path {
                    solvedGrid.set(p, c: "O")
                }
                print(solvedGrid)
                print("Shortest path is \(path.count - 1) steps.")
            }
            toFall += 1
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
    let graph = Graph(from: maze)
    let (_, prev) = dijkstra(graph, source: start)
    return sequence(prev: prev, source: start, target: end)
}

/// Parse a string like `3,-2` into a `Point(x: 3, y: -2)`.
private func parsePoint(_ input: String.SubSequence) -> Point {
    let elements = input.split { $0 == "," }
    let x = Int(String(elements[0]))!
    let y = Int(String(elements[1]))!
    return Point(x: x, y: y)
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
