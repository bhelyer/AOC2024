class Day11: Program {
    func run(input: String) throws {
        let stones = input.split { $0.isWhitespace }.map { String($0) }
        try part1(input: stones)
        try part2(input: stones)
    }
    
    func part1(input: [String]) throws {
        print("len1=\(blink(stones: input, times: 25))")
    }
    
    func part2(input: [String]) throws {
        var stoneCounts: [String: Int] = [:] // problem says order matters -- it doesn't
        for stone in input {
            stoneCounts[stone] = (stoneCounts[stone] ?? 0) + 1
        }
        
        for _ in 0..<75 {
            var backCounts = stoneCounts
            for (stone, count) in stoneCounts {
                if stone == "0" {
                    backCounts[stone] = (backCounts[stone] ?? 0) - count
                    backCounts["1"] = (backCounts["1"] ?? 0) + count
                } else if stone.count % 2 == 0 {
                    let newStones = split(stone)
                    backCounts[stone] = (backCounts[stone] ?? 0) - count
                    backCounts[newStones[0]] = (backCounts[newStones[0]] ?? 0) + count
                    backCounts[newStones[1]] = (backCounts[newStones[1]] ?? 0) + count
                } else {
                    backCounts[stone] = (backCounts[stone] ?? 0) - count
                    let newStone = String(Int(stone)! * 2024)
                    backCounts[newStone] = (backCounts[newStone] ?? 0) + count
                }
            }
            stoneCounts = backCounts
        }
        
        var sum = 0
        for (_, count) in stoneCounts {
            sum += count
        }
        print("len2=\(sum)")
    }
}

func blink(stones: [String], times: Int) -> Int {
    var stones = stones
    for _ in 0..<times {
        //print("\r\(i)            ")
        stones = blink(stones: stones)
    }
    return stones.count
}

func blink(stones: [String]) -> [String] {
    var result: [String] = []
    for stone in stones {
        result.append(contentsOf: blink(stone: stone))
    }
    return result
}

func blink(stone: String) -> [String] {
    if stone == "0" {
        return ["1"]
    } else if stone.count % 2 == 0 {
        return split(stone)
    } else {
        return [String(Int(stone)! * 2024)]
    }
}

nonisolated(unsafe) var splitCache: [String: [String]] = [:]
func split(_ stone: String) -> [String] {
    if let result = splitCache[stone] {
        return result
    }
    let chars = [Character](stone)
    let i = stone.count / 2
    let result = [String(Int(String(chars[0..<i]))!),
                  String(Int(String(chars[i..<chars.count]))!)]
    splitCache[stone] = result
    return result
}
