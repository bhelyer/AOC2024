class Day14: Program {
    func run(input: String) throws {
        try Day14.part1(input: input)
        try Day14.part2(input: input)
    }
    
    static func part1(input: String) throws {
        let robots = parseRobots(from: input)
        let dimensions = if robots.count > 20 {
            // Real input.
            Point(x: 101, y: 103)
        } else {
            // Sample input.
            Point(x: 11, y: 7)
        }
        let finalState = simulate(initial: robots, mapSize: dimensions, forSeconds: 100)
        print("Safety Factor=\(calculateSafetyFactor(robots: finalState, mapSize: dimensions))")
    }
    
    static func part2(input: String) throws {
        var robots = parseRobots(from: input)
        let dimensions = if robots.count > 20 {
            // Real input.
            Point(x: 101, y: 103)
        } else {
            // Sample input.
            Point(x: 11, y: 7)
        }
        for i in 0..<Int.max {
            robots = simulate(initial: robots, mapSize: dimensions, forSeconds: 1)
            var grid = Grid(dimensions: dimensions, c: ".")
            for robot in robots {
                grid.set(robot.pos, c: "R")
            }
            if grid.findFirst(s: "RRRR") != nil {
                print("N=\(i)")
                print(grid)
            }
        }
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
    var simulatedRobots = robots

    for _ in 0..<n {
        for i in 0..<simulatedRobots.count {
            simulatedRobots[i] = simulate(robot: simulatedRobots[i], mapSize: mapSize)
        }
    }

    return simulatedRobots
}

func simulate(robot: Robot, mapSize: Point) -> Robot {
    let nextPos = robot.pos + robot.vel
    var x = nextPos.x
    var y = nextPos.y
    if y < 0 {
        y += mapSize.y
    } else if y >= mapSize.y {
        y -= mapSize.y
    }
    if x < 0 {
        x += mapSize.x
    } else if x >= mapSize.x {
        x -= mapSize.x
    }
    return Robot(pos: Point(x: x, y: y), vel: robot.vel)
}

func calculateSafetyFactor(robots: [Robot], mapSize: Point) -> Int {
    let hw = mapSize.x / 2
    let hh = mapSize.y / 2
    // A|B
    // -+-
    // C|D
    var a = 0
    var b = 0
    var c = 0
    var d = 0

    for robot in robots {
        if robot.pos.x < hw && robot.pos.y < hh {
            a += 1
        } else if robot.pos.x > hw && robot.pos.y < hh {
            b += 1
        } else if robot.pos.x < hw && robot.pos.y > hh {
            c += 1
        } else if robot.pos.x > hw && robot.pos.y > hh {
            d += 1
        }
    }

    return a * b * c * d
}
