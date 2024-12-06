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
