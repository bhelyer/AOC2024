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
    let lines = input.split { $0.isNewline }
    var robots: [Robot] = []

    for line in lines {
        guard let robot = parseRobot(line: line) else {
            continue
        }
        robots.append(robot)
    }

    return robots
}

func parseRobot(line: String.SubSequence) -> Robot? {
    let arr = [Character](line)
    guard let firstEquals = arr.firstIndex(where: { $0 == "=" }) else {
        return nil
    }
    guard let firstSpace = arr.firstIndex(where: { $0 == " "}) else {
        return nil
    }
    guard let lastEquals = arr.lastIndex(where: { $0 == "=" }) else {
        return nil
    }
    guard let pos = parsePoint(from: arr[firstEquals+1..<firstSpace]) else {
        return nil
    }
    guard let vel = parsePoint(from: arr[lastEquals+1..<arr.count]) else {
        return nil
    }
    return Robot(pos: pos, vel: vel)
}

func parsePoint(from arr: ArraySlice<Character>) -> Point? {
    guard let comma = arr.firstIndex(where: { $0 == "," }) else {
        return nil
    }
    guard let x = Int(String(arr[arr.startIndex..<comma])) else {
        return nil
    }
    guard let y = Int(String(arr[comma+1..<arr.endIndex])) else {
        return nil
    }
    return Point(x: x, y: y)
}

func simulate(initial robots: [Robot], mapSize: Point, forSeconds n: Int) -> [Robot] {
    return robots
}

func calculateSafetyFactor(robots: [Robot]) -> Int {
    return 0
}
