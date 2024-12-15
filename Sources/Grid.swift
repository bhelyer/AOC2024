/// A two-dimensional array of characters.
struct Grid: CustomStringConvertible {
    /// The width of the grid, in characters.
    public let width: Int
    /// The height of the grid in characters.
    public let height: Int
    private var grid: [[Character]]
    
    /// Create a `Grid` from an input string.
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
    
    init(dimensions: Point, c: Character) {
        self.width = dimensions.x
        self.height = dimensions.y
        var arrays: [[Character]] = []
        for _ in 0..<dimensions.y {
            arrays.append([Character](repeating: c, count: dimensions.x))
        }
        self.grid = arrays
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
    
    mutating func set(_ p: Point, c: Character) {
        if inBounds(p) {
            grid[p.y][p.x] = c
        }
    }
    
    func inBounds(_ p: Point) -> Bool {
        return p.x >= 0 && p.x < width && p.y >= 0 && p.y < height
    }
    
    /// Find the first position of a matching character, or `nil` if it couldn't be found.
    func findFirst(c: Character) -> Point? {
        for y in 0..<height {
            for x in 0..<width {
                let p = Point(x: x, y: y)
                if get(p) == c {
                    return p
                }
            }
        }
        return nil
    }
    
    /// Find a horizontal string of characters.
    func findFirst(s: String) -> Point? {
        let arr = Array<Character>(s)
        for y in 0..<height {
            for x in 0..<width {
                var found = true
                for i in arr.startIndex..<arr.endIndex {
                    let p = Point(x: x + i, y: y)
                    if get(p) != arr[i] {
                        found = false
                        break
                    }
                }
                if found {
                    return Point(x: x, y: y)
                }
            }
        }
        return nil
    }
    
    /// Find the first position of a non-matching character, or `nil` if it couldn't be found.
    func findFirstNot(c: Character) -> Point? {
        for y in 0..<height {
            for x in 0..<width {
                let p = Point(x: x, y: y)
                if get(p) != c {
                    return p
                }
            }
        }
        return nil
    }
    
    /// Calculate the number of instances of `c` in the grid.
    func count(c: Character) -> Int {
        var sum = 0
        for y in 0..<height {
            for x in 0..<width {
                let p = Point(x: x, y: y)
                if get(p) == c {
                    sum += 1
                }
            }
        }
        return sum
    }
    
    var description: String {
        var str = ""
        for y in 0..<height {
            for x in 0..<width {
                str.append(grid[y][x])
            }
            str.append("\n")
        }
        return str
    }
}
