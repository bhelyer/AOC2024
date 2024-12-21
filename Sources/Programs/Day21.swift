class Day21: Program {
    func run(input: String) async throws {
        print("Day 21, part 1 = \(part1(input))")
    }

    private func part1(_ input: String) -> Int {
        let codes = input.split { $0.isNewline }
        var sum = 0
        for code in codes {
            sum += complexity(code)
        }
        return sum
    }
}

private func complexity(_ code: Substring) -> Int {
    return shortestSequence(code).count * numericPortion(code)
}

private func shortestSequence(_ code: Substring) -> [Character] {
    return [">"]
}

/// Given `029A` return `29`.
private func numericPortion(_ code: Substring) -> Int {
    return Int(String([Character](code)[0..<3]))!
}
