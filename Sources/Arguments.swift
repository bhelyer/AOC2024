import Foundation

/// Errors thrown while parsing arguments.
enum ArgumentError: Error {
    /// There weren't enough arguments; there has to be at least three.
    case insufficientArguments
}

/// The arguments that were passed to this program.
struct Arguments {
    /// The name of the program to run, like `day1`.
    let programName: String
    /// The name of the input file to load, like `input.txt`
    let inputPath: URL
    
    /// Parse an `Arguments` from a list of arguments, like `CommandLine.arguments`.
    /// (That is, the first arg is expected to be the executable name.)
    init(_ args: [String]) throws {
        if args.count != 3 {
            throw ArgumentError.insufficientArguments
        }
        programName = args[1]
        inputPath = URL(filePath: args[2], directoryHint: .notDirectory)
    }
}
