class Day8: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let grid = try Grid(input)
        let antennaLists = findFrequencies(grid)
        var antinodeSet = Set<Point>()
        for antennaList in antennaLists {
            let antinodeLocations = findAntinodeLocations(antennaList)
            for antinodeLocation in antinodeLocations {
                if grid.inBounds(antinodeLocation) {
                    antinodeSet.insert(antinodeLocation)
                }
            }
        }
        print("Unique Antinode Locations (1) = \(antinodeSet.count)")
    }
    
    func part2(input: String) throws {
        let grid = try Grid(input)
        let antennaLists = findFrequencies(grid)
        var antinodeSet = Set<Point>()
        for antennaList in antennaLists {
            let antinodeLocations = findAntinodeLocations2(grid, antennaList)
            for antinodeLocation in antinodeLocations {
                antinodeSet.insert(antinodeLocation)
            }
        }
        print("Unique Antinode Locations (2) = \(antinodeSet.count)")
    }
}

func findFrequencies(_ grid: Grid) -> [[Point]] {
    var frequencies: [Character: [Point]] = [:]
    for y in 0..<grid.height {
        for x in 0..<grid.width {
            let p = Point(x: x, y: y)
            let c = grid.get(p)
            guard c != "." else {
                continue
            }
            if !frequencies.keys.contains(c) {
                frequencies[c] = []
            }
            var array = frequencies[c]!
            array.append(p)
            frequencies[c] = array
        }
    }
    var result: [[Point]] = []
    for (_, arr) in frequencies {
        result.append(arr)
    }
    return result
}

func findAntinodeLocations(_ points: [Point]) -> [Point] {
    var result: [Point] = []
    for i in 0..<points.count-1 {
        for j in i+1..<points.count {
            result.append(contentsOf: findAntinodeLocations(points[i], points[j]))
        }
    }
    return result
}

func findAntinodeLocations(_ a: Point, _ b: Point) -> [Point] {
    let abx = b.x - a.x
    let aby = b.y - a.y
    let bax = a.x - b.x
    let bay = a.y - b.y
    let an0 = Point(x: a.x - abx, y: a.y - aby)
    let an1 = Point(x: b.x - bax, y: b.y - bay)
    return [an0, an1]
}

func findAntinodeLocations2(_ grid: Grid, _ points: [Point]) -> [Point] {
    var result: [Point] = []
    for i in 0..<points.count-1 {
        for j in i+1..<points.count {
            result.append(contentsOf: findAntinodeLocations2(grid, points[i], points[j]))
        }
    }
    return result
}

func findAntinodeLocations2(_ grid: Grid, _ a: Point, _ b: Point) -> [Point] {
    var antinodes: [Point] = []
    let abx = b.x - a.x
    let aby = b.y - a.y
    let dp = Point(x: abx, y: aby)

    var p: Point = b
    while grid.inBounds(p) {
        antinodes.append(p)
        p = p + dp
    }
    
    p = a
    while grid.inBounds(p) {
        antinodes.append(p)
        p = p - dp
    }
    
    return antinodes
}
