class Day19: Program {
    func run(input: String) async throws {
        let lines = input.split { $0.isNewline }
        let towels = lines[0].split { $0 == "," }.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let patterns = lines[1..<lines.count]
        let possiblePatterns = patterns.filter { possible($0, towels) }
        print("Possible patterns = \(possiblePatterns.count)")
    }
}

private func possible(_ pattern: any StringProtocol,
                      _ towels: [String]) -> Bool {
    for towel in towels {
        if towel == pattern { return true }
        if pattern.hasPrefix(towel) {
            let i = pattern.index(pattern.startIndex, offsetBy: towel.count)
            if possible(pattern[i...], towels) { return true }
        }
    }
    return false
}
