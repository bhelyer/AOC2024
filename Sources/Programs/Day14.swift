class Day14: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let robots = parseRobots(from: input)
        let dimensions = if robots.count > 20 {
            // Real input.
            Point(x: 101, y: 103)
        } else {
            // Sample input.
            Point(x: 11, y: 7)
        }
        let finalState = simulate(initial: robots, mapSize: dimensions, forSeconds: 100)
        print("Safety Factor=\(calculateSafetyFactor(robots: finalState))")
    }
    
    func part2(input: String) throws {
        print("Day 14, part 2.")
    }
}

struct Robot {
    let pos: Point
    let vel: Point
}

func parseRobots(from input: String) -> [Robot] {
    return []
}

func simulate(initial robots: [Robot], mapSize: Point, forSeconds n: Int) -> [Robot] {
    return robots
}

func calculateSafetyFactor(robots: [Robot]) -> Int {
    return 0
}
