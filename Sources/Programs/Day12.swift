class Day12: Program {
    func run(input: String) throws {
        try part1(input)
        try part2(input)
    }
    
    func part1(_ input: String) throws {
        let grid = try Grid(input)
        let regions = parseRegions(from: grid)
        var price = 0
        for region in regions {
            price += region.area * region.perimeter
        }
        print("Price = \(price)")
    }
    
    func part2(_ input: String) throws {
        let grid = try Grid(input)
        let regions = parseRegions(from: grid)
        var price = 0
        for region in regions {
            print(region)
            price += region.area * region.sides
        }
        print("Discount Price = \(price)")
    }
}

struct Region: CustomStringConvertible {
    let crop: Character
    let coordinates: [Point]
    
    var area: Int {
        return coordinates.count
    }
    
    var perimeter: Int {
        var sum = 0
        for p in coordinates {
            for dir in upDownLeftRight {
                let neighbour = p + dir
                if coordinates.count(where: { $0 == neighbour }) == 0 {
                    sum += 1
                }
            }
        }
        return sum
    }
    
    var sides: Int {
        let squares = coordinates.map { Square(point: $0, coordinates: coordinates) }
        return countSides(in: squares, side: \Square.upFenced, dirA: upDownLeftRight[2], dirB: upDownLeftRight[3]) +
        countSides(in: squares, side: \Square.downFenced, dirA: upDownLeftRight[2], dirB: upDownLeftRight[3]) +
        countSides(in: squares, side: \Square.leftFenced, dirA: upDownLeftRight[0], dirB: upDownLeftRight[1]) +
        countSides(in: squares, side: \Square.rightFenced, dirA: upDownLeftRight[0], dirB: upDownLeftRight[1])
    }
    
    var description: String {
        return "A region of `\(crop)` plants with price `\(area) * \(sides) = \(area * sides)`."
    }
}

func countSides(in squares: [Square], side: KeyPath<Square, Bool>, dirA: Point, dirB: Point) -> Int {
    var sides = 0
    var lookedAt = Set<Point>()
    for square in squares {
        if !square[keyPath: side] || lookedAt.contains(square.point) {
            continue
        }
        sides += 1
        // Remove connected sides.
        let connectedFences = connected(from: square, squares: squares, fence: side, dirA: dirA, dirB: dirB)
        for fence in connectedFences {
            lookedAt.insert(fence)
        }
    }
    return sides
}

func connected(from square: Square, squares: [Square], fence: KeyPath<Square, Bool>, dirA: Point, dirB: Point) -> [Point] {
    var connectedSquares = [square.point]
    var toTry = [square.point + dirA, square.point + dirB]
    while !toTry.isEmpty {
        let trying = toTry.popLast()!
        guard let tryingSquare = squares.first(where: { $0.point == trying }), tryingSquare[keyPath: fence] else {
            continue
        }
        connectedSquares.append(trying)
        let a = trying + dirA
        let b = trying + dirB
        if !connectedSquares.contains(a) { toTry.append(a) }
        if !connectedSquares.contains(b) { toTry.append(b) }
    }
    return connectedSquares
}

struct Square {
    let point: Point
    let upFenced: Bool
    let downFenced: Bool
    let leftFenced: Bool
    let rightFenced: Bool
    
    init(point: Point, coordinates: [Point]) {
        self.point = point
        self.upFenced = coordinates.count { $0 == point + upDownLeftRight[0] } == 0
        self.downFenced = coordinates.count { $0 == point + upDownLeftRight[1] } == 0
        self.leftFenced = coordinates.count { $0 == point + upDownLeftRight[2] } == 0
        self.rightFenced = coordinates.count { $0 == point + upDownLeftRight[3] } == 0
    }
}

func parseRegions(from grid: Grid) -> [Region] {
    var grid = grid
    var regions: [Region] = []
    
    // Basic algorithm:
    // 1. Find the first non '_' character.
    // 2. That's the region we're extracting. Set that point to '_'.
    // 3. Set all adjacent points of the same crop to '_'. Once done,
    //    add that region to the regions array.
    // 4. Repeat until the entire grid is '_'.
    let emptyCrop: Character = "_"
    while true {
        guard let p = grid.findFirstNot(c: emptyCrop) else {
            break
        }
        let crop = grid.get(p)
        grid.set(p, c: emptyCrop)
        var coordinates: [Point] = []
        var pointsToCheck = [p]
        var checkedPoints = Set<Point>()

        while !pointsToCheck.isEmpty {
            let current = pointsToCheck.removeFirst()
            coordinates.append(current)
            for dir in upDownLeftRight {
                let prospectivePoint = current + dir
                if checkedPoints.contains(prospectivePoint) {
                    continue
                }
                checkedPoints.insert(prospectivePoint)
                let prospectiveCrop = grid.get(prospectivePoint)
                if prospectiveCrop == crop {
                    pointsToCheck.append(prospectivePoint)
                    grid.set(prospectivePoint, c: emptyCrop)
                }
            }
        }
        regions.append(Region(crop: crop, coordinates: coordinates))
    }
    
    return regions
}
