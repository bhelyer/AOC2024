class Day13: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }

    func part1(input: String) throws {
        var sum = 0
        let clawMachines = parseClawMachines(input: input)
        for machine in clawMachines {
            let solutions = iterativeSolve(machine: machine)
            if let cheapestSolution = findCheapest(solutions: solutions) {
                sum += cost(cheapestSolution)
            }
        }
        print("Sum = \(sum)")
    }
    
    func part2(input: String) throws {
        print("Day 13, part 2.")
    }
}

struct ClawMachine {
    let a: Point
    let b: Point
    let target: Point
}

struct Solution {
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

func iterativeSolve(machine: ClawMachine) -> [Solution] {
    let maxInput = 100
    
    var solutions: [Solution] = []
    
    for a in 0...maxInput {
        for b in 0...maxInput {
            // ax + bx = tx
            // ay + by = ty
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

func findCheapest(solutions: [Solution]) -> Solution? {
    if solutions.isEmpty {
        return nil
    }
    var mut = solutions
    mut.sort { cost($0) < cost($1) }
    return mut.first!
}

func cost(_ solution: Solution) -> Int {
    return solution.a * 3 + solution.b
}
