class Day9: Program {
    func run(input: String) throws {
        try part1(input: input)
        try part2(input: input)
    }
    
    func part1(input: String) throws {
        let blocks = load(fromDiskMap: input)
        let compactedBlocks = compact(byBlock: blocks)
        print("Checksum = \(checksum(ofBlocks: compactedBlocks))")
    }
    
    func part2(input: String) throws {
        let blocks = load(fromDiskMap: input)
        let compactedBlocks = compact(byFile: blocks)
        print("Checksum = \(checksum(ofBlocks: compactedBlocks))")
    }
}

let emptyBlock = -1
typealias BlockMap = [Int]

func load(fromDiskMap input: String) -> BlockMap {
    var blocks: BlockMap = []
    var file = true
    var id = 0
    for c in input {
        let n = Int(String(c))
        guard let n else {
            break
        }
        if file {
            for _ in 0..<n {
                blocks.append(id)
            }
            id += 1
        } else {
            for _ in 0..<n {
                blocks.append(emptyBlock)
            }
        }
        file.toggle()
    }
    return blocks
}

func compact(byBlock blocks: BlockMap) -> BlockMap {
    var blocks = blocks
    while countGaps(blocks) > 0 {
        blocks = moveLastBlock(blocks)
    }
    return blocks
}

func compact(byFile blocks: BlockMap) -> BlockMap {
    var blocks = blocks
    var idToMove = blocks.last { $0 != emptyBlock }! // Find largest id.
    while idToMove >= 0 {
        blocks = tryToMoveFileLeft(blocks, fileId: idToMove)
        idToMove -= 1
    }
    return blocks
}

func tryToMoveFileLeft(_ blocks: BlockMap, fileId: Int) -> BlockMap {
    let startIndex = blocks.firstIndex { $0 == fileId }!
    let endIndex = blocks.lastIndex { $0 == fileId }!
    let emptyIndex = findEmptyGap(blocks, gapSize: endIndex - startIndex + 1)
    guard let emptyIndex, emptyIndex < startIndex else {
        return blocks
    }

    var blocks = blocks
    for i in startIndex...endIndex {
        blocks.swapAt(i, emptyIndex + (i - startIndex))
    }
    return blocks
}

func findEmptyGap(_ blocks: BlockMap, gapSize: Int) -> Int? {
    var currentGapIndex = -1
    var currentGapSize = 0
    for i in 0..<blocks.count {
        if currentGapSize >= gapSize {
            return currentGapIndex
        }
        if blocks[i] != emptyBlock {
            currentGapSize = 0
            currentGapIndex = -1
            continue
        }
        if currentGapIndex == -1 {
            currentGapIndex = i
        }
        currentGapSize += 1
    }
    return nil
}

func countGaps(_ blocks: BlockMap) -> Int {
    var gaps = 0
    var pendingGaps = 0
    for block in blocks {
        if block != emptyBlock {
            gaps += pendingGaps
            pendingGaps = 0
        } else {
            pendingGaps += 1
        }
    }
    return gaps
}

func moveLastBlock(_ blocks: BlockMap) -> BlockMap {
    let firstEmpty = blocks.firstIndex { $0 == emptyBlock }
    let lastNonEmpty = blocks.lastIndex { $0 != emptyBlock }
    guard let firstEmpty, let lastNonEmpty else {
        return blocks
    }
    var swapped = blocks
    swapped.swapAt(firstEmpty, lastNonEmpty)
    return swapped
}

func checksum(ofBlocks blocks: BlockMap) -> Int {
    var sum = 0
    for i in 0..<blocks.count {
        guard blocks[i] != emptyBlock else {
            continue
        }
        sum += blocks[i] * i
    }
    return sum
}
