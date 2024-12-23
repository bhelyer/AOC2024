class Day23: Program {
    var nodes: [Substring: [Substring]] = [:]
    var pairs: [(Substring, Substring)] = []

    func run(input: String) async throws {
        parse(input)
        print("Part 1 = \(part1())")
    }
    
    private func parse(_ input: String) {
        let lines = input.split { $0.isNewline }
        for line in lines {
            let halves = line.split { $0 == "-" }
            guard halves.count == 2 else { continue }
            
            nodes[halves[0], default: []].append(halves[1])
            nodes[halves[1], default: []].append(halves[0])
            pairs.append((halves[0], halves[1]))
        }
    }
    
    private func part1() -> Int {
        var trios =  Set<Trio>()
        for (a, _) in nodes {
            let aIsT = a.starts(with: "t")
            for (b, c) in pairs {
                let bIsT = b.starts(with: "t")
                let cIsT = c.starts(with: "t")
                guard aIsT || bIsT || cIsT else { continue }
                if nodes[b]!.contains(a) && nodes[c]!.contains(a) {
                    var arr = [a, b, c]
                    arr.sort()
                    trios.insert(Trio(arr[0], arr[1], arr[2]))
                }
            }
        }
        return trios.count
    }
}

private struct Trio: Hashable {
    let a: Substring
    let b: Substring
    let c: Substring
    
    init(_ a: Substring, _ b: Substring, _ c: Substring) {
        self.a = a
        self.b = b
        self.c = c
    }
}
