class Day7: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let equations = parseEquations(input)
        var sum = 0
        for equation in equations {
            if isSolvable(equation) {
                sum += equation.result
            }
        }
        print("Total Calibration Result = \(sum)")
    }
    
    func part2(input: String) throws {
        print("Day 7, part 2")
    }
}

enum Operator {
    case add
    case mul
}

func eval(_ a: Int, _ b: Int, _ op: Operator) -> Int {
    switch op {
    case .add: return a + b
    case .mul: return a * b
    }
}

struct Equation {
    let result: Int
    let operands: [Int]
    var operators: [Operator]
    
    init(_ result: Int, _ operands: [Int]) {
        self.result = result
        self.operands = operands
        self.operators = [Operator](repeating: .add, count: self.operands.count - 1)
    }
    
    func eval() -> Int {
        var operandsStack = reverse(operands)
        var operatorsStack = reverse(operators)
        while !operatorsStack.isEmpty {
            let op = operatorsStack.popLast()!
            let a = operandsStack.popLast()!
            let b = operandsStack.popLast()!
            operandsStack.append(Advent.eval(a, b, op))
        }
        return operandsStack[0]
    }
}

func reverse<T>(_ arr: [T]) -> [T] {
    var result: [T] = []
    for i in 0..<arr.count {
        result.append(arr[(arr.count - 1) - i])
    }
    return result
}

func parseEquations(_ input: String) -> [Equation] {
    let lines = input.split { $0.isNewline }
    var equations: [Equation] = []
    for line in lines {
        let resultOperands = line.split { $0 == ":" }
        if resultOperands.count != 2 {
            return []
        }
        let result = Int(resultOperands[0])!
        let operands = resultOperands[1].split { $0.isWhitespace }.map { Int($0)! }
        equations.append(Equation(result, operands))
    }
    return equations
}

func isSolvable(_ equation: Equation) -> Bool {
    let operatorLists = getAllPossibleOperators(equation)
    for operators in operatorLists {
        var testEquation = equation
        testEquation.operators = operators
        if testEquation.eval() == testEquation.result {
            return true
        }
    }
    return false
}

func getAllPossibleOperators(_ equation: Equation) -> [[Operator]] {
    var operatorLists: [[Operator]] = []
    let trials = 1 << equation.operators.count // 2^^count
    for i in 0..<trials {
        operatorLists.append(numberToOperators(i, size: equation.operators.count))
    }
    return operatorLists
}

func numberToOperators(_ i: Int, size: Int) -> [Operator] {
    var operators = [Operator](repeating: .add, count: size)
    for bit in 0..<size {
        let bitMask = 0x1 << bit
        if (i & bitMask) != 0 {
            operators[bit] = .mul
        }
    }
    return operators
}
