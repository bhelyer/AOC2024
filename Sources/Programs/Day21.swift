/*

I give up for now.
The path I'm generating for the numpad is wrong.
It's shortest in terms of points, but not in terms of minimising movement.
Probable better solution would be to manually think through the ideal
movement between all points and use that. 

 */

class Day21: Program {
    func run(input: String) async throws {
        print("Day 21, part 1 = \(part1(input))")
    }

    private func part1(_ input: String) -> Int {
        let codes = input.split { $0.isNewline }
        var sum = 0
        for code in codes {
            sum += complexity(code)
        }
        return sum
    }
}

private func complexity(_ code: Substring) -> Int {
    return shortestSequence(code).count * numericPortion(code)
}

private func shortestSequence(_ code: Substring) -> [Character] {
    print(code)
    let a = requiredDirInput(dirToNumpad: code)
    print(String(a))
    let b = requiredDirInput(dirToDir: a)
    print(String(b))
    let c = requiredDirInput(dirToDir: b)
    print("\(String(c)) (\(c.count))")
    return c
}

/// Given `029A` return `29`.
private func numericPortion(_ code: Substring) -> Int {
    return Int(String([Character](code)[0..<3]))!
}

private func requiredDirInput(dirToDir input: [Character]) -> [Character] {
    var characters: [Character] = []
    var currentPoint = Point(x: 2, y: 0)
    for c in input {
        let dest = dirpadPoint(from: c)
        let path = dirpadPath(start: currentPoint, end: dest)
        characters.append(contentsOf: path)
        characters.append("A")
        currentPoint = dest
    }
    return characters
}

/// Get the directional input required to command robot to
/// interact with the numpad to enter the given code.
private func requiredDirInput(dirToNumpad code: Substring) -> [Character] {
    var characters: [Character] = []
    var currentPoint = Point(x: 2, y: 3)
    for c in code {
        let dest = numpadPoint(from: c)
        let path = numpadPath(start: currentPoint, end: dest)
        characters.append(contentsOf: path)
        characters.append("A")
        currentPoint = dest
    }
    return characters
}

/// Given a dirpad key ('^', 'A', etc) return its `Point`.
private func dirpadPoint(from c: Character) -> Point {
    switch c {
    case "^": return Point(x: 1, y: 0)
    case "A": return Point(x: 2, y: 0)
    case "<": return Point(x: 0, y: 1)
    case "v": return Point(x: 1, y: 1)
    case ">": return Point(x: 2, y: 1)
    default: return Point()
    }
}

/// Given a numpad key ('2', 'A', etc) return its `Point`.
private func numpadPoint(from c: Character) -> Point {
    switch c {
    case "7": return Point(x: 0, y: 0)
    case "8": return Point(x: 1, y: 0)
    case "9": return Point(x: 2, y: 0)
    case "4": return Point(x: 0, y: 1)
    case "5": return Point(x: 1, y: 1)
    case "6": return Point(x: 2, y: 1)
    case "1": return Point(x: 0, y: 2)
    case "2": return Point(x: 1, y: 2)
    case "3": return Point(x: 2, y: 2)
    case "0": return Point(x: 1, y: 3)
    case "A": return Point(x: 2, y: 3)
    default: return Point()
    }
}

private func dirpadPath(start: Point, end: Point) -> [Character] {
    let (_, prev) = dirpadDijkstra(source: start)
    let pointPath = sequence(prev: prev, source: start, target: end)
    return toChars(pointPath)
}

private func numpadPath(start: Point, end: Point) -> [Character] {
    let (_, prev) = numpadDijkstra(source: start)
    let pointPath = sequence(prev: prev, source: start, target: end)
    return toChars(pointPath)
}

private typealias Dist = [Point: Double]
private typealias Prev = [Point: Point?]

private func dirpadDijkstra(source: Point) -> (Dist, Prev) {
    var dist: Dist = [:]
    var prev: Prev = [:]
    var q: [Point] = []

    for y in 0..<2 {
        for x in 0..<3 {
            let v = Point(x: x, y: y)
            if !validDirpadPoint(v) { continue }
            dist[v] = Double.infinity
            prev[v] = nil
            q.append(v)
        }
    }
    dist[source] = 0

    let d = { (v: Point) in
        return dist[v, default: Double.infinity]
    }
    while !q.isEmpty {
        q.sort { d($0) > d($1) }
        let u = q.popLast()!
        let adjacent = dirpadNeighbours(u)
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

private func numpadDijkstra(source: Point) -> (Dist, Prev) {
    var dist: Dist = [:]
    var prev: Prev = [:]
    var q: [Point] = []

    for y in 0..<4 {
        for x in 0..<3 {
            let v = Point(x: x, y: y)
            if !validNumpadPoint(v) { continue }
            dist[v] = Double.infinity
            prev[v] = nil
            q.append(v)
        }
    }
    dist[source] = 0

    let d = { (v: Point) in
        return dist[v, default: Double.infinity]
    }
    while !q.isEmpty {
        q.sort { d($0) > d($1) }
        let u = q.popLast()!
        let adjacent = numpadNeighbours(u)
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
    var u: Point? = target
    if prev[u!] != nil || u! == source {
        while u != nil {
            path.append(u!)
            u = prev[u!, default: nil]
        }
    }
    return path.reversed()
}

private func toChars(_ points: [Point]) -> [Character] {
    if points.isEmpty {
        return []
    }
    var chars: [Character] = []
    var currentPoint = points.first!
    for i in 1..<points.count {
        let delta = points[i] - currentPoint
        chars.append(toChar(delta))
        currentPoint = points[i]
    }
    return chars
}

private func toChar(_ p: Point) -> Character {
    switch p {
    case Point(x: 1, y: 0): return ">"
    case Point(x: 0, y: 1): return "v"
    case Point(x:-1, y: 0): return "<"
    case Point(x: 0, y:-1): return "^"
    default:
        print("Bad toChar point: \(p)")
        return "?"
    }
}

private func validNumpadPoint(_ p: Point) -> Bool {
    if p == Point(x: 0, y: 3) {
        // Blank space
        return false
    }
    return p.x >= 0 && p.x < 3 && p.y >= 0 && p.y < 4
}

private func validDirpadPoint(_ p: Point) -> Bool {
    if p == Point(x: 0, y: 0) {
        // Blank space.
        return false
    }
    return p.x >= 0 && p.x < 3 && p.y >= 0 && p.y < 2
}

private func numpadNeighbours(_ p: Point) -> [Point] {
    var points: [Point] = []
    for dir in upDownLeftRight {
        let maybe = p + dir
        if validNumpadPoint(maybe) {
            points.append(maybe)
        }
    }
    return points
}

private func dirpadNeighbours(_ p: Point) -> [Point] {
    var points: [Point] = []
    for dir in upDownLeftRight {
        let maybe = p + dir
        if validDirpadPoint(maybe) {
            points.append(maybe)
        }
    }
    return points
}
