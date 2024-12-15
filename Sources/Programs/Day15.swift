class Day15: Program {
    func run(input: String) async throws {
        let puzzle = Puzzle(parseFrom: input)
        let finalLayout = apply(moves: puzzle.moves, toLayout: puzzle.layout)
        let gpsScores = finalLayout.stones.map { calculateGpsCoordinate(stone: $0, mapSize: finalLayout.mapSize) }
        var sum = 0
        for gpsScore in gpsScores {
            sum += gpsScore
        }
        print("Day 15 Part 1 = \(sum)")
    }
}

struct Puzzle {
    let moves: [CardinalDirection]
    let layout: Layout

    init(parseFrom input: String) {
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
                    let p = currentPoint + Point(x: x, y: 0)
                    if arr[x] == "#" {
                        walls.append(p)
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
        self.layout = Layout(mapSize: Point(x: width, y: height), walls: walls, stones: stones, robot: robot)
    }
}

struct Layout: CustomStringConvertible {
    let mapSize: Point
    let walls: [Point]
    var stones: [Point]
    var robot: Point
    
    var description: String {
        var str = ""
        for y in 0..<mapSize.y {
            for x in 0..<mapSize.x {
                let p = Point(x: x, y: y)
                if let _ = walls.first(where: { $0 == p }) {
                    str += "#"
                } else if let _ = stones.first(where: { $0 == p }) {
                    str += "O"
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

func apply(moves: [CardinalDirection], toLayout layout: Layout) -> Layout {
    var layout = layout
    for move in moves {
        //print(move)
        //print(layout)
        apply(move: move, toLayout: &layout)
    }
    return layout
}

func apply(move: CardinalDirection, toLayout layout: inout Layout) {
    let nextPos = layout.robot + toPoint(dir: move)
    if let _ = layout.walls.first(where: { $0 == nextPos }) {
        // Walking into a wall.
        return
    }
    if let i = layout.stones.firstIndex(of: nextPos) {
        if !moveStone(move: move, stoneIndex: i, layout: &layout) {
            // Pushing a stone into a wall.
            return
        }
    }
    layout.robot = nextPos
}

func moveStone(move: CardinalDirection, stoneIndex: Int, layout: inout Layout) -> Bool {
    let nextPos = layout.stones[stoneIndex] + toPoint(dir: move)
    if let _ = layout.walls.first(where: { $0 == nextPos }) {
        // Pushing into a wall.
        return false
    }
    if let i = layout.stones.firstIndex(of: nextPos) {
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

func calculateGpsCoordinate(stone: Point, mapSize: Point) -> Int {
    return 100 * stone.y + stone.x
}
