enum Instruction {
    case mulInst
    case doInst
    case dontInst
}

func getInstruction(dont: Range<String.Index>?, do: Range<String.Index>?, mul: Range<String.Index>?) -> Instruction? {
    var ranges: [Range<String.Index>] = []
    if dont != nil { ranges.append(dont!) }
    if `do` != nil { ranges.append(`do`!) }
    if mul != nil { ranges.append(mul!) }
    if ranges.isEmpty { return nil }
    let lowestRange = ranges.sorted { $0.lowerBound < $1.lowerBound }.first
    if dont != nil && lowestRange == dont { return .dontInst }
    if `do` != nil && lowestRange == `do` { return .doInst }
    if mul != nil && lowestRange == mul { return .mulInst }
    return nil
}

class Day3: Program {
    let mulExp = /mul\((\d{1,3}),(\d{1,3})\)/
    let doExp = /do\(\)/
    let dontExp = /don't\(\)/
    
    func run(input: String) throws {
        var enabled = true
        var sum = 0
        var enabledSum = 0
        var asStr = String(input)
        while !asStr.isEmpty {
            let dontMatch = asStr.firstMatch(of: dontExp)
            let doMatch = asStr.firstMatch(of: doExp)
            let mulMatch = asStr.firstMatch(of: mulExp)
            let dontIdx = dontMatch?.range
            let doIdx = doMatch?.range
            let mulIdx = mulMatch?.range
            let inst = getInstruction(dont: dontIdx, do: doIdx, mul: mulIdx)
            if inst == nil {
                asStr = ""
                break
            }
            switch inst! {
            case .doInst:
                enabled = true
                asStr = String(asStr[doMatch!.range.upperBound...])
            case .dontInst:
                enabled = false
                asStr = String(asStr[dontMatch!.range.upperBound...])
            case .mulInst:
                let a = try Int(String(mulMatch!.output.1), format: .number)
                let b = try Int(String(mulMatch!.output.2), format: .number)
                sum += a * b
                if enabled {
                    enabledSum += a * b
                }
                asStr = String(asStr[mulMatch!.range.upperBound...])
            }
        }
        print("Sum = \(sum)")
        print("Enabled Sum = \(enabledSum)")
    }
}
