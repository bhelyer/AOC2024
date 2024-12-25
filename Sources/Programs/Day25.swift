class Day25: Program {
    var locks: [[Int]] = []
    var keys: [[Int]] = []

    func run(input: String) async throws {
        try parse(input)
        print("Day 25 part 1 = \(part1())")
    }
    
    private func parse(_ input: String) throws {
        let lines = input.split(maxSplits: Int.max, omittingEmptySubsequences: false) {
            $0.isNewline
        }
        var i = 0
        var state = ParseState.open
        while i < lines.count {
            let line = lines[i]
            state = try parse(state: state, line: line, index: &i)
        }
    }
    
    private func parse(state: ParseState, line: Substring, index: inout Int) throws -> ParseState {
        switch state {
        case .open: return try parseOpen(line: line, index: &index)
        case .parsingKey: return try parseKey(line: line, index: &index)
        case .parsingLock: return try parseLock(line: line, index: &index)
        }
    }
    
    private func parseOpen(line: Substring, index: inout Int) throws -> ParseState {
        if line.isEmpty {
            index += 1
            return .open
        }
        // We use -1 to avoid having to skip the filled line.
        if line.first! == "#" {
            locks.append([-1, -1, -1, -1, -1])
            return .parsingLock
        }
        if line.first! == "." {
            keys.append([-1, -1, -1, -1, -1])
            return .parsingKey
        }
        throw ProgramError.invalidInput
    }
    
    private func parseKey(line: Substring, index: inout Int) throws -> ParseState {
        if line.isEmpty {
            index += 1
            return .open
        }
        let arr = [Character](line)
        var key = keys.last!
        for i in 0..<key.count {
            if i >= arr.count {
                throw ProgramError.invalidInput
            }
            if arr[i] == "#" {
                key[i] += 1
            } else if arr[i] != "." {
                throw ProgramError.invalidInput
            }
        }
        keys[keys.count - 1] = key
        index += 1
        return .parsingKey
    }
    
    private func parseLock(line: Substring, index: inout Int) throws -> ParseState {
        if line.isEmpty {
            index += 1
            return .open
        }
        let arr = [Character](line)
        var lock = locks.last!
        for i in 0..<lock.count {
            if i >= arr.count {
                throw ProgramError.invalidInput
            }
            if arr[i] == "#" {
                lock[i] += 1
            } else if arr[i] != "." {
                throw ProgramError.invalidInput
            }
        }
        locks[locks.count - 1] = lock
        index += 1
        return .parsingLock
    }
    
    private func part1() -> Int {
        var sum = 0
        for lock in locks {
            for key in keys {
                var overlaps = 0
                for i in 0..<5 {
                    if lock[i] + key[i] > 5 {
                        overlaps += 1
                        break
                    }
                }
                if overlaps == 0 {
                    sum += 1
                }
            }
        }
        return sum
    }
}

private enum ParseState {
    case open
    case parsingKey
    case parsingLock
}
