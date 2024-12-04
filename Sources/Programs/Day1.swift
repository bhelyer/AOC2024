class Day1: Program {
    func run(input: String) throws {
        let lines = input.split { $0.isNewline }
        // Parse the input into two lists of integers.
        var list1 = [Int]()
        var list2 = [Int]()
        
        for line in lines {
            let numbers = line.components(separatedBy: "   ")
            if numbers.count != 2 {
                throw ProgramError.invalidInput
            }
            guard let number1 = Int(numbers[0]), let number2 = Int(numbers[1]) else {
                throw ProgramError.invalidInput
            }
            list1.append(number1)
            list2.append(number2)
        }
        
        // Sort the lists.
        if list1.count != list2.count {
            throw ProgramError.invalidInput
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

    }
}
