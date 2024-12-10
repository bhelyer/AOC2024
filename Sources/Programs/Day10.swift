class Day10: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let grid = try Grid(input)
        var sum = 0
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                let p = Point(x: x, y: y)
                if grid.get(p) != "0" {
                    continue
                }
                let reachableNines = findReachableNines(grid, startPoint: p)
                let uniqueNines = unique(reachableNines)
                sum += uniqueNines.count
            }
        }
        print("Trailhead Sum 1 = \(sum)")
    }
    
    func part2(input: String) throws {
        let grid = try Grid(input)
        var sum = 0
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                let p = Point(x: x, y: y)
                if grid.get(p) != "0" {
                    continue
                }
                let reachableNines = findReachableNines(grid, startPoint: p)
                sum += reachableNines.count
            }
        }
        print("Trailhead Sum 2 = \(sum)")
    }
}

let directions = [Point(x: 0, y: -1), Point(x: 0, y: 1), Point(x: -1, y: 0), Point(x: 1, y: 0)]

func findReachableNines(_ grid: Grid, startPoint p: Point) -> [Point] {
    var reachableNines: [Point] = []
    var toTry: [Point] = [p]
    while !toTry.isEmpty {
        guard let p = toTry.popLast() else {
            break
        }
        let c = grid.get(p)
        if c == "9" {
            reachableNines.append(p)
        }
        let n = Int(String(c))!
        for direction in directions {
            let nextP = p + direction
            if !grid.inBounds(nextP) {
                continue
            }
            let nextC = grid.get(nextP)
            let nextN = Int(String(nextC))!
            if nextN == n + 1 {
                toTry.append(nextP)
            }
        }
    }
    return reachableNines
}

func unique(_ arr: [Point]) -> [Point] {
    var result: [Point] = []
    for el in arr {
        if !result.contains(el) {
            result.append(el)
        }
    }
    return result
}

