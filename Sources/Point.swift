struct Point: Hashable {
    let x: Int
    let y: Int
    
    /// Create a point with an X and Y of 0.
    init() {
        self.x = 0
        self.y = 0
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

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

let upDownLeftRight = [Point(x: 0, y: -1), Point(x: 0, y: 1), Point(x: -1, y: 0), Point(x: 1, y: 0)]

enum CardinalDirection {
    case up
    case down
    case left
    case right
}
