/// Each day's puzzle is represented by a `Program`.
/// Use the `getProgram` function to create an instance.
@MainActor
protocol Program {
    func run(input: String) async throws
}

/// These can be thrown by `getProgram`, and `Program.run`
enum ProgramError: Error {
    case noSuchProgram
    case invalidInput
}

/// Get a `Program` instance by the specified name.
@MainActor
func getProgram(byName programName: String) throws -> Program {
    switch programName {
    case "day1": return Day1()
    case "day2": return Day2()
    case "day3": return Day3()
    case "day4": return Day4()
    case "day5": return Day5()
    case "day6": return Day6()
    case "day7": return Day7()
    case "day8": return Day8()
    case "day9": return Day9()
    case "day10": return Day10()
    case "day11": return Day11()
    case "day12": return Day12()
    case "day13": return Day13()
    case "day14": return Day14()
    case "day15": return Day15()
    case "day16": return Day16()
    case "day17": return Day17()
    case "day18": return Day18()
    case "day19": return Day19()
    case "day20": return Day20()
    case "day21": return Day21()
    case "day22": return Day22()
    case "day23": return Day23()
    default: throw ProgramError.noSuchProgram
    }
}
