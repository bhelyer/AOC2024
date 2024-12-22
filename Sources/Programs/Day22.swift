class Day22: Program {
    func run(input: String) async throws {
        let initialSecrets = input.split { $0.isNewline }.map { Int($0)! }
        var sum = 0
        for secret in initialSecrets {
            var advancedSecret = secret
            for _ in 0..<2000 {
                advancedSecret = advance(secret: advancedSecret)
            }
            print("\(secret): \(advancedSecret)")
            sum += advancedSecret
        }
        print("Sum = \(sum)")
    }
}

private func advance(secret: Int) -> Int {
    var secret = prune(mix(secret * 64, into: secret))
    secret = prune(mix(secret / 32, into: secret))
    return prune(mix(secret * 2048, into: secret))
}

private func mix(_ n: Int, into secret: Int) -> Int {
    return secret ^ n
}

private func prune(_ secret: Int) -> Int {
    return secret % 16777216
}
