import Foundation

func loadLines(fromFile url: URL) throws -> [String.SubSequence] {
    let fileString = try String(contentsOf: url, encoding: .utf8)
    return fileString.split { $0.isNewline }
}
