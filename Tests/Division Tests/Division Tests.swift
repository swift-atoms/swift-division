import Division
import Polarity
import Testing

@Suite
struct `Integer division preserves quotient and remainder invariants` {}

extension `Integer division preserves quotient and remainder invariants` {
    @Test
    func `Int8 Euclidean division agrees with a wider integer oracle`() throws {
        for dividend in Int16(-128)...127 {
            for divisor in Int16(1)...127 {
                let expected = dividend >= 0 ? dividend / divisor : (dividend - divisor + 1) / divisor
                let result = try Division.euclidean(Int8(dividend), by: Int8(divisor))
                #expect(Int16(result.quotient) == expected)
                #expect(Int16(result.remainder) == dividend - expected * divisor)
                #expect(result.remainder >= 0 && result.remainder < divisor)
            }
        }
    }

    @Test
    func `signed magnitude division preserves the full unsigned range`() throws {
        for magnitude in UInt16(0)...255 {
            for divisor in UInt16(1)...255 {
                for polarity: Polarity in [.positive, .negative] {
                    let dividend = polarity == .positive ? Int16(magnitude) : -Int16(magnitude)
                    let base = Int16(divisor)
                    let expected = dividend >= 0 ? dividend / base : (dividend - base + 1) / base
                    let result = try Division.Signed.euclidean(
                        magnitude: UInt8(magnitude), polarity: polarity, by: UInt8(divisor)
                    )
                    #expect(result.polarity == (expected < 0 ? .negative : .positive))
                    #expect(UInt16(result.quotient) == expected.magnitude)
                    #expect(Int16(result.remainder) == dividend - expected * base)
                }
            }
        }
    }

    @Test
    func `invalid division and exactness have explicit failures`() {
        #expect(throws: Division.Error.zero) { try Division.exact(UInt128(0), by: 0) }
        #expect(throws: Division.Error.overflow) { try Division.quotient(Int128.min, by: -1) }
        #expect(throws: Division.Error.inexact) { try Division.exact(Int128(-7), by: 3) }
        #expect(throws: Division.Error.negative) { try Division.euclidean(Int128(7), by: -3) }
    }

    @Test
    func `full-width boundaries remain exact`() throws {
        let result = try Division.euclidean(Int128.min, by: 3)
        #expect(result.quotient == Int128.min / 3 - 1)
        #expect(result.remainder == 1)
        #expect(try Division.exact(Int128.min, by: 1) == .min)
        let full = try Division.Signed.euclidean(magnitude: UInt128.max, polarity: .negative, by: 1)
        #expect(full.quotient == .max && full.remainder == 0 && full.polarity == .negative)
    }
}
