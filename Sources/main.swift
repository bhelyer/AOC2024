/// Very simple frontend to load advent programs.
/// Usage: `advent dayn input.txt`
import Foundation

// Find the program to run and run it with the input split into lines.
do {
    let argument = try Arguments(CommandLine.arguments)
    let program = try getProgram(byName: argument.programName)
    let lines = try loadLines(fromFile: argument.inputPath)
    try program.run(lines)
} catch {
    print("Error: \(error)")
    exit(1)
}
