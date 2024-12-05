class Day5: Program {
    func run(input: String) throws {
        let rules = parseRules(from: input)
        let updates = parseUpdates(from: input)
        
        // Part 1, sum of correct updates.
        let correctUpdates = updates.filter { validate(update: $0, against: rules) }
        var sum = 0
        for correctUpdate in correctUpdates {
            let middleIndex = correctUpdate.count / 2
            sum += correctUpdate[middleIndex]
        }
        
        // Part 2, sum of corrected updates.
        let correctedUpdates = updates.filter { !validate(update: $0, against: rules) }
            .map { correctUpdate(update: $0, against: rules) }
        var correctedSum = 0
        for correctedUpdate in correctedUpdates {
            let middleIndex = correctedUpdate.count / 2
            correctedSum += correctedUpdate[middleIndex]
        }
        
        print("Correct Sum = \(sum)")
        print("Corrected Sum = \(correctedSum)")
    }
}

struct Rule {
    let pre: Int
    let post: Int
}

typealias Update = [Int]

func parseRules(from input: String) -> [Rule] {
    let lines = input.split { $0.isNewline }
    var rules: [Rule] = []
    for line in lines {
        guard !line.isEmpty else {
            break
        }
        let pages = line.split { $0 == "|" }
        guard pages.count == 2 else {
            break
        }
        let pre = Int(pages[0])
        let post = Int(pages[1])
        guard pre != nil && post != nil else {
            break
        }
        rules.append(Rule(pre: pre!, post: post!))
    }
    return rules
}

func parseUpdates(from input: String) -> [Update] {
    let lines = input.split { $0.isNewline }
    var updates: [Update] = []
    for line in lines {
        let pages = line.split { $0 == "," }
        if pages.count <= 1 {
            continue
        }
        let update = pages.map { Int($0)! }
        updates.append(update)
    }
    return updates
}

/// Returns true if `update` doesn't break any of the `Rule`s in the given Rules.
func validate(update: Update, against rules: [Rule]) -> Bool {
    for rule in rules {
        if !validate(update: update, against: rule) {
            return false
        }
    }
    return true
}

/// Return true if `update` doesn't break the given `Rule`.
func validate(update: Update, against rule: Rule) -> Bool {
    let pre = update.firstIndex(of: rule.pre)
    let post = update.firstIndex(of: rule.post)
    if pre == nil || post == nil {
        return true
    }
    return pre! < post!
}

func correctUpdate(update: Update, against rules: [Rule]) -> Update {
    var mutUpdate = update
    while !validate(update: mutUpdate, against: rules) {
        for rule in rules {
            if !validate(update: mutUpdate, against: rule) {
                mutUpdate = fix(update: mutUpdate, wrt: rule)
            }
        }
    }
    return mutUpdate
}

func fix(update: Update, wrt rule: Rule) -> Update {
    var mutUpdate = update
    let pre = update.firstIndex(of: rule.pre)
    let post = update.firstIndex(of: rule.post)
    mutUpdate.swapAt(pre!, post!)
    return mutUpdate
}
