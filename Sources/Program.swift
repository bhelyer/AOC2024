/// Each day's puzzle is represented by a `Program`.
/// Use the `getProgram` function to create an instance.
protocol Program {
    func run(_ lines: [String.SubSequence]) throws
}

/// These can be thrown by `getProgram`, and `Program.run`
enum ProgramError: Error {
    case noSuchProgram
    case invalidInput
}

/// Get a `Program` instance by the specified name.
func getProgram(byName programName: String) throws -> Program {
    switch programName {
    case "day1": return Day1()
    case "day2": return Day2()
    case "day3": return Day3()
    default: throw ProgramError.noSuchProgram
    }
}
