extension Regex<Substring> {
    /// Return the number of times this `Regex` can be found in a given `Substring`.
    func count(in string: Substring) -> Int {
        var sum = 0
        var a = string.startIndex
        let b = string.endIndex
        while a < b {
            let subString = string[a..<b]
            let match = subString.firstMatch(of: self)
            guard let match else {
                break
            }
            sum += 1
            a = match.range.upperBound
        }
        return sum
    }
    
    func count(in string: String) -> Int {
        var sum = 0
        var a = string.startIndex
        let b = string.endIndex
        while a < b {
            let subString = string[a..<b]
            let match = subString.firstMatch(of: self)
            guard let match else {
                break
            }
            sum += 1
            a = match.range.upperBound
        }
        return sum
    }
}

func makeHorizontal(_ string: String) throws -> [Substring] {
    return string.split { $0.isNewline }
}

func makeVertical(_ string: String) throws -> [String] {
    let lines = string.split { $0.isNewline }
    guard !lines.isEmpty && !lines[0].isEmpty else {
        throw ProgramError.invalidInput
    }
    var verticalLines = [String](repeating: "", count: lines[0].count)
    for line in lines {
        if line.isEmpty {
            break
        }
        let arr = Array(line)
        if verticalLines.count > arr.count {
            throw ProgramError.invalidInput
        }
        for i in 0..<verticalLines.count {
            verticalLines[i].append(arr[i])
        }
    }
    return verticalLines
}

struct Point {
    let x: Int
    let y: Int
    
    static func ==(left: Point, right: Point) -> Bool {
        return left.x == right.x && left.y == right.y
    }
    
    static func !=(left: Point, right: Point) -> Bool {
        return left.x != right.x || left.y != right.y
    }
    
    static func +(left: Point, right: Point) -> Point {
        return Point(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: Point, right: Point) -> Point {
        return Point(x: left.x - right.x, y: left.y - right.y)
    }
}

func inBounds(grid lines: [Substring], _ point: Point) -> Bool {
    return point.y >= 0 && point.y < lines.count && point.x >= 0 && point.x < lines[0].count
}

func get(from lines: [Substring], at point: Point) -> Character {
    return Array(lines[point.y])[point.x]
}

func buildDiagonalLine(from lines: [Substring], startingAt point: Point, delta: Point) -> String {
    var line = ""
    var currentPoint = point
    while inBounds(grid: lines, currentPoint) {
        line.append(get(from: lines, at: currentPoint))
        currentPoint = currentPoint + delta
    }
    return line
}

func makeDiagonal(_ string: String) throws -> [String] {
    let lines = string.split { $0.isNewline }
    
    var diagonalLines: [String] = []
    var currentPoint = Point(x: 0, y: lines.count - 1)
    // down and to the right
    let endPoint = Point(x: lines[0].count, y: 0)
    while currentPoint != endPoint {
        diagonalLines.append(buildDiagonalLine(from: lines, startingAt: currentPoint, delta: Point(x: 1, y: 1)))
        if currentPoint.y > 0 {
            currentPoint = currentPoint - Point(x: 0, y: 1)
        } else {
            currentPoint = currentPoint + Point(x: 1, y: 0)
        }
    }
    // down and the left
    currentPoint = Point(x: 0, y: 0)
    let endPoint2 = Point(x: lines[0].count - 1, y: lines.count)
    while currentPoint != endPoint2 {
        diagonalLines.append(buildDiagonalLine(from: lines, startingAt: currentPoint, delta: Point(x: -1, y: 1)))
        if currentPoint.x < lines[0].count - 1 {
            currentPoint = currentPoint + Point(x: 1, y: 0)
        } else {
            currentPoint = currentPoint + Point(x: 0, y: 1)
        }
    }
    
    return diagonalLines
}

/// A two-dimensional array of characters.
struct WordGrid {
    /// The width of the grid, in characters.
    public let width: Int
    /// The height of the grid in characters.
    public let height: Int
    private let grid: [[Character]]

    /// Create a `WordGrid` from an input string.
    /// This should be lines of the same width or something will explode.
    init(_ input: String) throws {
        let lines = input.split { $0.isNewline }
        guard !lines.isEmpty && !lines[0].isEmpty else {
            throw ProgramError.invalidInput
        }
        width = lines[0].count
        height = lines.count
        // Convert the array of Substrings into an array of an array of Characters.
        var arrays: [[Character]] = []
        for line in lines {
            arrays.append(Array(line))
        }
        grid = arrays
    }
    
    /// Look up the `Character` at the given coordinates.
    /// If the point is out of bounds, a space is returned.
    func get(_ p: Point) -> Character {
        guard p.x >= 0 && p.x < width && p.y >= 0 && p.y < height else {
            // Out of bounds.
            return " "
        }
        return grid[p.y][p.x]
    }
}

func isMS(_ a: Character, _ b: Character) -> Bool {
    return (a == "M" && b == "S") || (a == "S" && b == "M")
}

/// Returns `true` if `centre` is the centre point of an X-MAS pattern.
func isXMas(_ grid: WordGrid, centre: Point) -> Bool {
    // If the centre isn't 'A', then this isn't an X-MAS.
    if grid.get(centre) != "A" {
        return false
    }
    // Check both the diagonals for M and S.
    let nw = centre - Point(x: 1, y: 1)
    let se = centre + Point(x: 1, y: 1)
    let ne = centre + Point(x: 1, y: -1)
    let sw = centre + Point(x: -1, y: 1)
    return isMS(grid.get(nw), grid.get(se)) && isMS(grid.get(ne), grid.get(sw))
}

class Day4: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let xmasExp = /XMAS/
        let samxExp = /SAMX/
        let horizontalLines = try makeHorizontal(input)
        let verticalLines = try makeVertical(input)
        let diagonalLines = try makeDiagonal(input)
        var xmasCount = 0
        for line in horizontalLines {
            xmasCount += xmasExp.count(in: line)
            xmasCount += samxExp.count(in: line)
        }
        for line in verticalLines {
            xmasCount += xmasExp.count(in: line)
            xmasCount += samxExp.count(in: line)
        }
        for line in diagonalLines {
            xmasCount += xmasExp.count(in: line)
            xmasCount += samxExp.count(in: line)
        }
        print("Xmas Count = \(xmasCount)")
    }
    
    func part2(input: String) throws {
        var xMasCount = 0
        let grid = try WordGrid(input)
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                if isXMas(grid, centre: Point(x: x, y: y)) {
                    xMasCount += 1
                }
            }
        }
        print("X-Mas Count = \(xMasCount)")
    }
}
