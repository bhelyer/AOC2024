/// Very simple frontend to load advent programs.
/// Usage: `advent dayn input.txt`
import Foundation

// Find the program to run and run it with the input split into lines.
do {
    let argument = try Arguments(CommandLine.arguments)
    let program = try getProgram(byName: argument.programName)
    let inputStr = try String(contentsOf: argument.inputPath, encoding: .utf8)
    let clock = ContinuousClock()
    let duration = try clock.measure { try program.run(input: inputStr) }
    print("Run Time = \(duration)")
} catch {
    print("Error: \(error)")
    exit(1)
}
