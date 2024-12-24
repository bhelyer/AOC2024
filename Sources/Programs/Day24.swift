class Day24: Program {
    func run(input: String) async throws {
        let wires = parseWires(from: input)
        print("Part 1 = \(part1(wires))")
    }
    
    private func part1(_ wires: Wires) -> Int {
        var zs: [any Wire] = []
        for (name, wire) in wires.dict {
            if name.starts(with: "z") {
                zs.append(wire)
            }
        }
        zs.sort {
            let a = $0.name.firstIndex { $0.isNumber }!
            let b = $1.name.firstIndex { $0.isNumber }!
            return Int($0.name[a...])! < Int($1.name[b...])!
        }
        var result = 0
        for i in 0..<zs.count {
            if zs[i].output() != 0 { result |= (1 << i) }
        }
        return result
    }
}

private protocol Wire {
    var name: Substring { get }
    
    func output() -> Int
}

private typealias Wires = SharedDictionary<Substring, any Wire>

private struct InputWire: Wire {
    var name: Substring
    var value: Int
    
    init(name: Substring, value: Int) {
        self.name = name
        self.value = value
    }
    
    func output() -> Int {
        return value
    }
}

private enum LogicGate {
    case and
    case or
    case xor
}

private struct LogicWire: Wire {
    var wires: Wires
    var name: Substring
    var lhs: Substring
    var rhs: Substring
    var gate: LogicGate
    
    init(wires: Wires, name: Substring, lhs: Substring, rhs: Substring, gate: LogicGate) {
        self.wires = wires
        self.name = name
        self.lhs = lhs
        self.rhs = rhs
        self.gate = gate
    }
    
    func output() -> Int {
        let a = wires[lhs]!.output()
        let b = wires[rhs]!.output()
        switch gate {
        case .and: return a & b
        case .or: return a | b
        case .xor: return a ^ b
        }
    }
}

private func parseWires(from input: String) -> Wires {
    let wires = Wires()
    let lines = input.split { $0.isNewline }
    for line in lines {
        if line.isEmpty { continue }
        if line.firstIndex(of: ":") != nil {
            parseInputWire(from: line, into: wires)
        } else {
            parseLogicWire(from: line, into: wires)
        }
    }
    return wires
}

private func parseInputWire(from input: Substring, into wires: Wires) {
    let halves = input.split { $0 == ":" }
    wires[halves[0]] = InputWire(name: halves[0], value: Int(halves[1].trimmingCharacters(in: .whitespaces))!)
}

private func parseLogicWire(from input: Substring, into wires: Wires) {
    let gate = toLogicGate(from: input)
    var input = input
    let firstSpaceIndex = input.firstIndex(of: " ")!
    let lhs = input[input.startIndex..<firstSpaceIndex]
    let first = input.index(after: firstSpaceIndex)
    input = input[first...]
    let secondSpaceIndex = input.firstIndex(of: " ")!
    let second = input.index(after: secondSpaceIndex)
    input = input[second...]
    let thirdSpaceIndex = input.firstIndex(of: " ")!
    let third = input.index(before: thirdSpaceIndex)
    let rhs = input[...third]
    input = input[input.index(after: thirdSpaceIndex)...]
    let fourthSpaceIndex = input.firstIndex(of: " ")!
    let fourth = input.index(after: fourthSpaceIndex)
    let name = input[fourth...]
    wires[name] = LogicWire(wires: wires, name: name, lhs: lhs, rhs: rhs, gate: gate)
}

private func toLogicGate(from: Substring) -> LogicGate {
    if from.contains("AND") {
        return .and
    } else if from.contains("XOR") {
        return .xor
    } else {
        return .or
    }
}

class SharedDictionary<K : Hashable, V> {
    var dict : Dictionary<K, V> = Dictionary()
    subscript(key : K) -> V? {
        get {
            return dict[key]
        }
        set(newValue) {
            dict[key] = newValue
        }
    }
}
