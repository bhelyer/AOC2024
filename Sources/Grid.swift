/// A two-dimensional array of characters.
struct Grid {
    /// The width of the grid, in characters.
    public let width: Int
    /// The height of the grid in characters.
    public let height: Int
    private let grid: [[Character]]
    
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
