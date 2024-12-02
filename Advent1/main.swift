//
//  main.swift
//  Advent1
//
//  Created by Bernard Helyer on 02/12/2024.
//

import Foundation

// Validate command line arguments.
if CommandLine.arguments.count != 2 {
    print("Usage: \(CommandLine.arguments[0]) <input file>")
    exit(1)
}

// Load the input into a string.
let url = URL(filePath: CommandLine.arguments[1])
guard let input = try? String(contentsOf: url, encoding: .utf8) else {
    print("Failed to read from '\(url)'.")
    exit(1)
}

// Parse the input into two lists of integers.
var list1 = [Int]()
var list2 = [Int]()

let lines = input.split { $0.isNewline }
for line in lines {
    let numbers = line.components(separatedBy: "   ")
    if numbers.count != 2 {
        print("Error: invalid input line '\(line)'")
        exit(1)
    }
    guard let number1 = Int(numbers[0]), let number2 = Int(numbers[1]) else {
        print("Error: invalid input line '\(line)'")
        exit(1)
    }
    list1.append(number1)
    list2.append(number2)
}

// Sort the lists.
if list1.count != list2.count {
    print("Uneven list sizes.")
    exit(1)
}

// Calculate the total distance, and similarity score.
list1.sort()
list2.sort()

var sum = 0
var similarityScore = 0
for i in 0 ..< list1.count {
    sum += abs(list1[i] - list2[i])
    similarityScore += list1[i] * list2.count {
        $0 == list1[i]
    }
}

print("Total Distance = \(sum)")
print("Similarity Score = \(similarityScore)")

