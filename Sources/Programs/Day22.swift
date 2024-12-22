class Day22: Program {
    func run(input: String) async throws {
        let initialSecrets = input.split { $0.isNewline }.map { Int($0)! }
        for var secret in initialSecrets {
            for _ in 0...10 {
                print(secret)
                secret = advance(secret: secret)
            }
        }
    }
}

private func advance(secret: Int) -> Int {
    return secret
}
