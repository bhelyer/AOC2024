import Darwin

class Day15: Program {
    func run(input: String) async throws {
        print("Day 15 Part 1 = \(part1(input: input))")
        print("Day 15 Part 2 = \(part2(input: input))")
    }
    
    func part1(input: String) -> Int {
        let puzzle = Puzzle(parseFrom: input, wide: false)
        let finalLayout = apply(moves: puzzle.moves, toLayout: puzzle.layout, print: false)
        let gpsScores = finalLayout.stones.map { calculateGpsCoordinate(stone: $0, mapSize: finalLayout.mapSize) }
        var sum = 0
        for gpsScore in gpsScores {
            sum += gpsScore
        }
        return sum
    }
    
    func part2(input: String) -> Int {
        let puzzle = Puzzle(parseFrom: input, wide: true)
        let finalLayout = apply(moves: puzzle.moves, toLayout: puzzle.layout, print: false)
        let gpsScores = finalLayout.stones.map { calculateGpsCoordinate(stone: $0, mapSize: finalLayout.mapSize) }
        var sum = 0
        for gpsScore in gpsScores {
            sum += gpsScore
        }
        return sum
    }
}

struct Puzzle {
    let moves: [CardinalDirection]
    let layout: Layout

    init(parseFrom input: String, wide: Bool) {
        let lines = input.split { $0.isNewline }
        var width = 0
        var height = 0
        var currentPoint = Point()
        var walls: [Point] = []
        var stones: [Point] = []
        var robot = Point()
        var moves: [CardinalDirection] = []
        for line in lines {
            let arr = [Character](line)
            if arr.first == nil || arr.first!.isWhitespace {
                continue
            }
            if arr.first! == "#" {
                height += 1
                width = line.count
                for x in 0..<arr.count {
                    let p = currentPoint + Point(x: x * (wide ? 2 : 1), y: 0)
                    if arr[x] == "#" {
                        walls.append(p)
                        if wide { walls.append(p + upDownLeftRight[3]) }
                    } else if arr[x] == "O" {
                        stones.append(p)
                    } else if arr[x] == "@" {
                        robot = p
                    }
                }
                currentPoint = currentPoint + Point(x: 0, y: 1)
            } else {
                for c in line {
                    switch c {
                    case "<": moves.append(.left)
                    case ">": moves.append(.right)
                    case "^": moves.append(.up)
                    default: moves.append(.down)
                    }
                }
            }
        }
        self.moves = moves
        self.layout = Layout(mapSize: Point(x: width * (wide ? 2 : 1), y: height),
                             wide: wide, walls: walls, stones: stones, robot: robot)
    }
}

struct Layout: CustomStringConvertible {
    let mapSize: Point
    let wide: Bool
    let walls: [Point]
    var stones: [Point]
    var robot: Point
    
    func firstStoneIndex(of p: Point) -> Int? {
        if let leftI = stones.firstIndex(of: p) {
            return leftI
        }
        if !wide {
            return nil
        }
        if let rightI = stones.firstIndex(of: p + upDownLeftRight[2]) {
            return rightI
        }
        return nil
    }
    
    func validate(against layout: Layout) -> Bool {
        if !layout.wide {
            return true
        }
        let againstStr = layout.description
        let expectedWalls = againstStr.count { $0 == "#" }
        let expectedFloors = againstStr.count { $0 == "." }
        let expectedLeftStones = againstStr.count { $0 == "[" }
        let expectedRightStones = againstStr.count { $0 == "]" }
        let expectedRobots = 1

        let ourStr = description
        let actualWalls = ourStr.count { $0 == "#" }
        let actualFloors = ourStr.count { $0 == "." }
        let actualLeftStones = ourStr.count { $0 == "[" }
        let actualRightStones = ourStr.count { $0 == "]" }
        let actualRobots = ourStr.count { $0 == "@" }
        
        return actualWalls == expectedWalls && actualFloors == expectedFloors &&
        actualLeftStones == expectedLeftStones && actualRightStones == expectedRightStones &&
        actualRobots == expectedRobots
    }

    var description: String {
        var str = ""
        for y in 0..<mapSize.y {
            for x in 0..<mapSize.x {
                let p = Point(x: x, y: y)
                if let _ = walls.first(where: { $0 == p }) {
                    str += "#"
                } else if let _ = stones.first(where: { $0 == p }) {
                    str += wide ? "[" : "O"
                } else if wide, let _ = stones.first(where: { $0 == p + upDownLeftRight[2] }) {
                    str += "]"
                } else if robot == p {
                    str += "@"
                } else {
                    str += "."
                }
            }
            str += "\n"
        }
        return str
    }
}

func apply(moves: [CardinalDirection], toLayout layout: Layout, print printMoves: Bool) -> Layout {
    if printMoves { print("INITIAL") }
    if printMoves { print(layout) }
    
    var layout = layout
    for move in moves {
        if printMoves { print(move) }
        apply(move: move, toLayout: &layout)
        if printMoves { print(layout) }
    }
    return layout
}

func apply(move: CardinalDirection, toLayout layout: inout Layout) {
    let nextPos = layout.robot + toPoint(dir: move)
    if let _ = layout.walls.first(where: { $0 == nextPos }) {
        // Walking into a wall.
        return
    }
    if let i = layout.firstStoneIndex(of: nextPos) {
        if !moveStone(move: move, stoneIndex: i, layout: &layout) {
            // Pushing a stone into a wall.
            return
        }
    }
    layout.robot = nextPos
}

func moveStone(move: CardinalDirection, stoneIndex: Int, layout: inout Layout) -> Bool {
    if layout.wide && (move == .up || move == .down) {
        return moveWideStone(move: move, stoneIndex: stoneIndex, layout: &layout)
    }
    let nextPos = layout.stones[stoneIndex] + toPoint(dir: move)
    var pushPos = nextPos
    if layout.wide && move == .right {
        pushPos = pushPos + Point(x: 1, y: 0)
    }
    if let _ = layout.walls.first(where: { $0 == pushPos }) {
        // Pushing into a wall.
        return false
    }
    if let i = layout.firstStoneIndex(of: pushPos) {
        assert(i != stoneIndex)
        // Pushing into another stone.
        if moveStone(move: move, stoneIndex: i, layout: &layout) {
            layout.stones[stoneIndex] = nextPos
            return true
        } else {
            return false
        }
    }
    // Pushing onto empty space.
    layout.stones[stoneIndex] = nextPos
    return true
}

func moveWideStone(move: CardinalDirection, stoneIndex: Int, layout: inout Layout) -> Bool {
    assert(move == .up || move == .down)
    assert(layout.wide)
    
    let nextL = layout.stones[stoneIndex] + toPoint(dir: move)
    let nextR = layout.stones[stoneIndex] + upDownLeftRight[3] + toPoint(dir: move)
    if let _ = layout.walls.first(where: { $0 == nextL}) {
        return false
    }
    if let _ = layout.walls.first(where: { $0 == nextR}) {
        return false
    }
    let lIndex = layout.firstStoneIndex(of: nextL)
    let rIndex = layout.firstStoneIndex(of: nextR)
    if lIndex != nil && rIndex != nil && lIndex! == rIndex! {
        // Pushing into another (single) stone.
        if moveStone(move: move, stoneIndex: lIndex!, layout: &layout) {
            layout.stones[stoneIndex] = nextL
            return true
        } else {
            return false
        }
    }
    if lIndex != nil && rIndex != nil {
        // Pushing into multiple stones.
        let lOriginalPos = layout.stones[lIndex!]
        if !moveStone(move: move, stoneIndex: lIndex!, layout: &layout) {
            return false;
        }
        if moveStone(move: move, stoneIndex: rIndex!, layout: &layout) {
            layout.stones[stoneIndex] = nextL
            return true
        } else {
            // Have to undo the first move.
            layout.stones[lIndex!] = lOriginalPos
            return false
        }
    }
    if (lIndex != nil && rIndex == nil) || (lIndex == nil && rIndex != nil) {
        if lIndex != nil {
            if moveStone(move: move, stoneIndex: lIndex!, layout: &layout) {
                layout.stones[stoneIndex] = nextL
                return true
            } else {
                return false
            }
        } else {
            if moveStone(move: move, stoneIndex: rIndex!, layout: &layout) {
                layout.stones[stoneIndex] = nextL
                return true
            } else {
                return false
            }
        }
    }
    // Pushing onto empty space.
    layout.stones[stoneIndex] = nextL
    return true
}

func calculateGpsCoordinate(stone: Point, mapSize: Point) -> Int {
    return 100 * stone.y + stone.x
}
