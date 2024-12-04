private enum LevelDirection {
    case increase
    case decrease
    case noChange
}

private func direction(_ a: Int, _ b: Int) -> LevelDirection {
    if a > b {
        return .increase
    } else if a < b {
        return .decrease
    } else {
        return .noChange
    }
}

private let maxSafeChange = 3
private func isSafe(lastDirection: LevelDirection?, _ a: Int, _ b: Int) -> Bool {
    let dir = direction(a, b)
    if dir == .noChange {
        return false
    }
    if lastDirection != nil && dir != lastDirection! {
        return false
    }
    return abs(a - b) <= maxSafeChange
}

/// A report is safe if all the levels are:
///  - All increasing or all decreasing.
///  - Any two adjacent levels differ by at least one and at most three.
private func isSafe(_ report: [Int]) -> Bool {
    var lastDirection: LevelDirection?
    var safe = true
    for i in 0..<report.count - 1 {
        let a = report[i]
        let b = report[i + 1]
        if !isSafe(lastDirection: lastDirection, a, b) {
            //print("UNSAFE: \(report), i:\(i)")
            safe = false
            break
        }
        lastDirection = direction(a, b)
    }
    return safe
}

/// The problem dampener allows a report to be safe if removing one level
/// would make it so.
private func isSafeWithDampener(_ report: [Int]) -> Bool {
    // Remove each level in turn and check if that makes it safe.
    for i in 0..<report.count {
        var testReport = report
        testReport.remove(at: i)
        if isSafe(testReport) {
            return true
        }
    }
    return false
}

class Day2: Program {
    func run(_ lines: [String.SubSequence]) throws {
        var safeReports = 0
        for reportLine in lines {
            let report = reportLine.split { $0.isWhitespace }.map { Int($0)! }
            if isSafe(report) || isSafeWithDampener(report) {
                safeReports += 1
            }
        }
        
        print("Safe Reports = \(safeReports)")
    }
}
