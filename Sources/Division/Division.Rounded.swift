public import Rounding

extension Division {



    public static func rounded<Value: FixedWidthInteger & SignedInteger>(
        _ dividend: Value, by divisor: Value, rounding: Rounding = .down
    ) throws(Error) -> (quotient: Value, remainder: Value) {
        let result = try quotient(dividend, by: divisor)
        let remainder = result.remainder.magnitude
        guard remainder != 0 else { return result }
        let complement = divisor.magnitude - remainder
        let comparison: Comparison = remainder < complement ? .less : (remainder > complement ? .greater : .equal)
        let negative = (dividend < 0) != (divisor < 0)
        let increment: Bool
        do {
            increment = try rounding.incrementsMagnitude(
                isNegative: negative,
                integralPartIsOdd: result.quotient % 2 != 0,
                fractionComparedToHalf: comparison
            )
        } catch { throw .inexact }
        guard increment else { return result }
        let roundedQuotient = negative
            ? result.quotient.subtractingReportingOverflow(1)
            : result.quotient.addingReportingOverflow(1)
        let residual = negative
            ? result.remainder.addingReportingOverflow(divisor)
            : result.remainder.subtractingReportingOverflow(divisor)
        guard !roundedQuotient.overflow, !residual.overflow else { throw .overflow }
        return (roundedQuotient.partialValue, residual.partialValue)
    }
}
