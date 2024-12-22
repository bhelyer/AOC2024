import Darwin.C

class Day22: Program {
    func run(input: String) async throws {
        let initialSecrets = input.split { $0.isNewline }.map { Int($0)! }
        print("Sum = \(part1(initialSecrets))")
        print("Max Bananas = \(await part2(initialSecrets))")
    }
    
    private func part1(_ input: [Int]) -> Int {
        var sum = 0
        for secret in input {
            var advancedSecret = secret
            for _ in 0..<2000 {
                advancedSecret = advance(secret: advancedSecret)
            }
            sum += advancedSecret
        }
        return sum
    }
    
    private func part2(_ input: [Int]) async -> Int {
        let prices = getPriceEntryLists(initialSecrets: input)

        // ...a miracle occurs...
        let series = await findBestSeries(prices)
        print("Best series = \(series)")
        
        var sum = 0
        var i = 0
        for priceEntries in prices {
            let price = purchaseBananas(from: priceEntries, lookFor: series)
            print("\(input[i]): \(price)")
            i += 1
            sum += price
        }
        return sum
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

private func onesDigit(_ secret: Int) -> Int {
    return secret % 10
}

private struct PriceEntry: Hashable {
    let price: Int
    let change: Int
}

private func getPriceEntryLists(initialSecrets: [Int]) -> [[PriceEntry]] {
    var priceEntries = [[PriceEntry]](repeating: [], count: initialSecrets.count)
    for i in 0..<initialSecrets.count {
        priceEntries[i] = getPriceEntries(secret: initialSecrets[i])
    }
    return priceEntries
}

private func getPriceEntries(secret: Int) -> [PriceEntry] {
    var priceEntries: [PriceEntry] = []
    var currentSecret = secret
    var lastValue = 0
    for i in 0..<2000 {
        currentSecret = advance(secret: currentSecret)
        let price = onesDigit(currentSecret)
        if i == 0 {
            lastValue = price
            continue
        }
        priceEntries.append(PriceEntry(price: price, change: price - lastValue))
        lastValue = price
    }
    return priceEntries
}

private func purchaseBananas(from priceEntries: [PriceEntry], lookFor: [Int]) -> Int {
    for i in 3..<priceEntries.count {
        if priceEntries[i].change == lookFor[3] &&
           priceEntries[i - 1].change == lookFor[2] &&
           priceEntries[i - 2].change == lookFor[1] &&
           priceEntries[i - 3].change == lookFor[0] {
            return priceEntries[i].price
        }
    }
    return 0
}

private func findBestSeries(_ priceEntries: [[PriceEntry]]) async -> [Int] {
    var opportunities: [SellOpportunity] = []
    for priceEntry in priceEntries {
        opportunities.append(contentsOf: getSellOpportunities(priceEntry))
    }
    
    var bestPrice = Int.min
    var bestSequence: [Int] = []
    var i = 0, j = 0
    let batchSize = 8
    opportunities.sort { $0.price > $1.price }
    while i < opportunities.count {
        await withTaskGroup(of: SellOpportunity.self) { taskGroup in
            for opportunity in opportunities[i..<min(i+batchSize, opportunities.count)] {
                taskGroup.addTask {
                    var thisPrice = 0
                    for priceEntry in priceEntries {
                        thisPrice += purchaseBananas(from: priceEntry, lookFor: opportunity.sequence)
                    }
                    return SellOpportunity(price: thisPrice, sequence: opportunity.sequence)
                }
            }
            
            for await opportunity in taskGroup {
                j += 1
                if opportunity.price > bestPrice {
                    bestPrice = opportunity.price
                    bestSequence = opportunity.sequence
                }
                print("\r\(j)/\(opportunities.count) p=\(bestPrice) s=\(bestSequence)               ", terminator: "")
                fflush(stdout)
            }
            i += batchSize
        }
    }
    return bestSequence
}

private struct SellOpportunity {
    let price: Int
    let sequence: [Int]
}

private func getSellOpportunities(_ priceEntries: [PriceEntry]) -> [SellOpportunity] {
    var opportunities: [SellOpportunity] = []
    for i in 3..<priceEntries.count {
        let price = priceEntries[i].price
        guard price > 0 else {
            continue
        }
        let sequence = [
            priceEntries[i - 3].change,
            priceEntries[i - 2].change,
            priceEntries[i - 1].change,
            priceEntries[i - 0].change
        ]
        opportunities.append(SellOpportunity(price: price, sequence: sequence))
    }
    return opportunities
}
