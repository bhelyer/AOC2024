class Day17: Program {
    func run(input: String) async throws {
        var computer = Computer(input: input)
        computer.run()
    }
}

private struct Computer: CustomStringConvertible {
    var a: Int = 0
    var b: Int = 0
    var c: Int = 0
    var ip: Int = 0
    var program: [Int] = []

    init(input: String) {
        let lines = input.split { $0.isNewline }
        for line in lines {
            if line.starts(with: /Register A:/) {
                a = parseRegister(line)
            } else if line.starts(with: /Register B:/) {
                b = parseRegister(line)
            } else if line.starts(with: /Register C:/) {
                c = parseRegister(line)
            } else if line.starts(with: /Program:/) {
                program = parseProgram(line)
            }
        }
    }
    
    var description: String {
        return "a=\(a) b=\(b) c=\(c) ip=\(ip)\nprogram=\(program)"
    }
    
    mutating func run() {
        while ip < program.count {
            //print(description)
            let instruction = program[ip]
            let operand = program[ip + 1]
            //print("run: \(instruction) \(operand)")
            execute(instruction: instruction, operand: operand)
        }

        print("") // Print a newline.
    }
    
    mutating func execute(instruction: Int, operand: Int) {
        switch instruction {
        case 0: adv(operand)
        case 1: bxl(operand)
        case 2: bst(operand)
        case 3: jnz(operand)
        case 4: bxc(operand)
        case 5: out(operand)
        case 6: bdv(operand)
        case 7: cdv(operand)
        default: break
        }
    }
    
    mutating func adv(_ operand: Int) {
        a = a >> combo(operand)
        ip += 2
    }
    
    mutating func bxl(_ operand: Int) {
        b = b ^ operand
        ip += 2
    }
    
    mutating func bst(_ operand: Int) {
        b = combo(operand) % 8
        ip += 2
    }
    
    mutating func jnz(_ operand: Int) {
        if a != 0 {
            ip = operand
        } else {
            ip += 2
        }
    }
    
    mutating func bxc(_ operand: Int) {
        b = b ^ c
        ip += 2
    }
    
    mutating func out(_ operand: Int) {
        print("\(combo(operand) % 8),", terminator: "")
        ip += 2
    }
    
    mutating func bdv(_ operand: Int) {
        b = a >> combo(operand)
        ip += 2
    }
    
    mutating func cdv(_ operand: Int) {
        c = a >> combo(operand)
        ip += 2
    }
    
    func combo(_ operand: Int) -> Int {
        switch operand {
        case 4: return a
        case 5: return b
        case 6: return c
        case 7: print("ERROR 7")
        default: break
        }
        return operand
    }
}

private func parseRegister(_ line: String.SubSequence) -> Int {
    let arr = [Character](line)
    guard let startIndex = arr.lastIndex(of: " ") else {
        return 0
    }
    let str = String(arr[startIndex+1..<arr.endIndex])
    guard let register = Int(str) else {
        return 0
    }
    return register
}

private func parseProgram(_ line: String.SubSequence) -> [Int] {
    let arr = [Character](line)
    guard let startIndex = arr.firstIndex(of: " ") else {
        return []
    }
    let ops = arr[startIndex+1..<arr.endIndex].split { $0 == "," }
    var program: [Int] = []
    for opStr in ops {
        guard let op = Int(String(opStr).trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return []
        }
        program.append(op)
    }
    return program
}
