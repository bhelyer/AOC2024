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
        return 0
    }
    
    var description: String {
        return "A region of `\(crop)` plants with price `\(area) * \(sides) = \(area * sides)`."
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
