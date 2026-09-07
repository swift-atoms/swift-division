import Division
import Testing

@Suite struct RoundedDivisionBoundaryTests {
    @Test func signedMinimaAndExactness() throws {
        #expect(try Division.rounded(-1, by: 2, rounding: .away).quotient == -1)
        #expect(try Division.rounded(8, by: 3, rounding: .odd).quotient == 3)
        #expect(throws: Division.Error.inexact) { try Division.rounded(5, by: 2, rounding: .exact) }
        #expect(try Division.rounded(Int8(100), by: 127, rounding: .even).quotient == 1)
        let parts = try Division.rounded(Int8.min, by: 3)
        #expect(parts.quotient == -43 && parts.remainder == 1)
        #expect(try Division.rounded(Int8(1), by: .min, rounding: .away).quotient == -1)
        #expect(throws: Division.Error.overflow) { try Division.rounded(Int8.min, by: -1) }
        #expect(throws: Division.Error.zero) { try Division.rounded(Int8(1), by: 0) }
    }

    @Test func everySignedBytePairAgreesWithWiderOracle() throws {
        let rules: [(Rounding, FloatingPointRoundingRule)] = [
            (.down, .down), (.up, .up), (.zero, .towardZero), (.away, .awayFromZero),
            (.even, .toNearestOrEven), (.nearest(.away), .toNearestOrAwayFromZero),
        ]
        for a in -128...127 {
            for b in -128...127 where b != 0 && !(a == -128 && b == -1) {
                for (rule, oracleRule) in rules {
                    let result = try Division.rounded(Int8(a), by: Int8(b), rounding: rule)
                    #expect(Int(result.quotient) == Int((Double(a) / Double(b)).rounded(oracleRule)))
                    #expect(Int(result.quotient) * b + Int(result.remainder) == a)
                }
            }
        }
    }
}
