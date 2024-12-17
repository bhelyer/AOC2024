class Day13: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }

    func part1(input: String) throws {
        var sum = 0
        let clawMachines = parseClawMachines(input: input)
        for machine in clawMachines {
            let solutions = iterativeSolve(machine: machine, maxInput: 100)
            if let cheapestSolution = findCheapest(solutions: solutions) {
                sum += cost(cheapestSolution)
            }
        }
        print("Sum = \(sum)")
    }
    
    func part2(input: String) throws {
        var sum = 0
        let initialClawMachines = parseClawMachines(input: input)
        let clawMachines = initialClawMachines.map {
            ClawMachine(a: $0.a, b: $0.b, target: $0.target + Point(x: 10000000000000, y: 10000000000000))
        }
        for machine in clawMachines {
            let solutions = solve(machine: machine)
            if let cheapestSolution = findCheapest(solutions: solutions) {
                sum += cost(cheapestSolution)
            }
        }
        print("Sum = \(sum)")
    }
}

struct ClawMachine {
    let a: Point
    let b: Point
    let target: Point
}

private struct Solution {
    let a: Int
    let b: Int
}

func parseClawMachines(input: String) -> [ClawMachine] {
    let lines = input.split { $0.isNewline }

    var currentA = Point()
    var currentB = Point()
    var target = Point()
    var machines: [ClawMachine] = []

    for line in lines {
        if line.starts(with: /Button A/) {
            currentA = parseButtonLine(line: line)!
        } else if line.starts(with: /Button B/) {
            currentB = parseButtonLine(line: line)!
        } else if line.starts(with: /Prize/) {
            target = parsePrizeLine(line: line)!
            machines.append(ClawMachine(a: currentA, b: currentB, target: target))
        }
    }

    return machines;
}

/// Parse a line like `Button A: X+15, Y+52` into a Point.
func parseButtonLine(line: String.SubSequence) -> Point? {
    let chars = Array<Character>(line)
    guard let firstPlus = chars.firstIndex(where: { $0 == "+" }) else {
        return nil
    }
    guard let firstComma = chars.firstIndex(where: { $0 == "," }) else {
        return nil
    }
    guard let lastPlus = chars.lastIndex(where: { $0 == "+" }) else {
        return nil
    }
    
    let x = Int(String(chars[firstPlus+1..<firstComma]))!
    let y = Int(String(chars[lastPlus+1..<chars.count]))!
    return Point(x: x, y: y)
}

/// Parse a line like `Prize: X=8400, Y=5400` into a Point.
func parsePrizeLine(line: String.SubSequence) -> Point? {
    let chars = Array<Character>(line)
    guard let firstEquals = chars.firstIndex(where: { $0 == "=" }) else {
        return nil
    }
    guard let firstComma = chars.firstIndex(where: { $0 == "," }) else {
        return nil
    }
    guard let lastEquals = chars.lastIndex(where: { $0 == "=" }) else {
        return nil
    }
    
    let x = Int(String(chars[firstEquals+1..<firstComma]))!
    let y = Int(String(chars[lastEquals+1..<chars.count]))!
    return Point(x: x, y: y)
}

private func iterativeSolve(machine: ClawMachine, maxInput: Int) -> [Solution] {
    var solutions: [Solution] = []
    
    for a in 0...maxInput {
        for b in 0...maxInput {
            let tx = a * machine.a.x + b * machine.b.x
            if tx != machine.target.x {
                continue
            }
            let ty = a * machine.a.y + b * machine.b.y
            if ty != machine.target.y {
                continue
            }
            solutions.append(Solution(a: a, b: b))
        }
    }

    return solutions
}

private func findCheapest(solutions: [Solution]) -> Solution? {
    if solutions.isEmpty {
        return nil
    }
    var mut = solutions
    mut.sort { cost($0) < cost($1) }
    return mut.first!
}

private func cost(_ solution: Solution) -> Int {
    return solution.a * 3 + solution.b
}

private func solve(machine: ClawMachine) -> [Solution] {
    // 1. Decide which unknown you wish to eliminate.
    let a0 = machine.a.x
    let a1 = machine.a.y
    // 2. Find the least common multiple (lcm).
    let m = lcm(a0, a1)
    let a0m = m / a0
    let a1m = m / a1
    // 3. Multiply the equations by the above.
    let scaledA0 = a0 * a0m
    let scaledA1 = a1 * a1m
    let scaledB0 = machine.b.x * a0m
    let scaledB1 = machine.b.y * a1m
    let scaledT0 = machine.target.x * a0m
    let scaledT1 = machine.target.y * a1m
    if scaledA0 != scaledA1 {
        return []
    }
    // Using the above, find a solution for B.
    var b: Int = 0
    if scaledB0 > scaledB1 {
        let bM = scaledB0 - scaledB1
        if bM == 0 {
            return []
        }
        b = (scaledT0 - scaledT1) / bM
    } else {
        let bM = scaledB1 - scaledB0
        if bM == 0 {
            return []
        }
        b = (scaledT1 - scaledT0) / bM
    }
    // Using B, find a solution for A.
    let a = (machine.target.x - machine.b.x * b) / machine.a.x
    let solution = Solution(a: a, b: b)
    if !check(machine: machine, solution: solution) {
        return []
    } else {
        return [solution]
    }
}

func lcm(_ a: Int, _ b: Int) -> Int {
    return a * b / gcd(a, b)
}

func gcd(_ a: Int, _ b: Int) -> Int {
    var a = a
    var b = b
    while b != 0 {
        let t = b
        b = a % b
        a = t
    }
    return a
}

private func check(machine: ClawMachine, solution: Solution) -> Bool {
    return (machine.a.x * solution.a + machine.b.x * solution.b == machine.target.x) &&
           (machine.a.y * solution.a + machine.b.y * solution.b == machine.target.y)
}
