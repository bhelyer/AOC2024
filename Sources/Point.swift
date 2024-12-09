struct Point: Hashable {
    let x: Int
    let y: Int

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
