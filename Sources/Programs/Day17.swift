class Day17: Program {
    func run(input: String) async throws {
        var computer = Computer(input: input)
        computer.run()
    }
}

private struct Computer {
    var a: Int = 0
    var b: Int = 0
    var c: Int = 0
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
    
    mutating func run() {
        print("a = \(a)")
        print("b = \(b)")
        print("c = \(c)")
        print("program = \(program)")
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
