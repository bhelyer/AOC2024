class Day23: Program {
    func run(input: String) async throws {
        let connections = parseConnections(from: input)
        print("Part 1 = \(part1(connections))")
    }
    
    private func part1(_ connections: [Connection]) -> Int {
        print(connections)
        return 0
    }
}

private struct Connection {
    let first: Substring
    let second: Substring
}

private func parseConnections(from input: String) -> [Connection] {
    let lines = input.split { $0.isNewline }
    var connections: [Connection] = []
    for line in lines {
        let halves = line.split { $0 == "-" }
        guard halves.count == 2 else { continue }
        connections.append(Connection(first: halves[0], second: halves[1]))
    }
    return connections
}
