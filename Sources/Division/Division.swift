public import Addition
public import Polarity
public import Subtraction


public enum Division {}

extension Division {
    public enum Error: Swift.Error, Hashable, Sendable {
        case zero
        case negative
        case overflow
        case inexact
    }


    @inlinable
    public static func quotient<Value: FixedWidthInteger>(
        _ dividend: Value, by divisor: Value
    ) throws(Error) -> (quotient: Value, remainder: Value) {
        guard divisor != .zero else { throw .zero }
        let quotient = dividend.dividedReportingOverflow(by: divisor)
        guard !quotient.overflow else { throw .overflow }
        return (quotient.partialValue, dividend % divisor)
    }


    @inlinable
    public static func exact<Value: FixedWidthInteger>(
        _ dividend: Value, by divisor: Value
    ) throws(Error) -> Value {
        let result = try quotient(dividend, by: divisor)
        guard result.remainder == .zero else { throw .inexact }
        return result.quotient
    }


    @inlinable
    public static func euclidean<Value: FixedWidthInteger & SignedInteger>(
        _ dividend: Value, by divisor: Value
    ) throws(Error) -> (quotient: Value, remainder: Value) {
        guard divisor >= .zero else { throw .negative }
        let result = try quotient(dividend, by: divisor)
        guard result.remainder < .zero else { return result }
        do {
            return (
                try Subtraction.exact(result.quotient, 1),
                try Addition.exact(result.remainder, divisor)
            )
        } catch { throw .overflow }
    }

    public enum Signed {}
}

extension Division.Signed {




    @inlinable
    public static func euclidean<Storage: FixedWidthInteger & UnsignedInteger>(
        magnitude: Storage, polarity: Polarity, by divisor: Storage
    ) throws(Division.Error) -> (polarity: Polarity, quotient: Storage, remainder: Storage) {
        let result = try Division.quotient(magnitude, by: divisor)
        guard polarity == .negative else {
            return (.positive, result.quotient, result.remainder)
        }
        guard result.remainder != .zero else {
            return (result.quotient == .zero ? .positive : .negative, result.quotient, .zero)
        }
        do {
            return (
                .negative,
                try Addition.exact(result.quotient, 1),
                try Subtraction.exact(divisor, result.remainder)
            )
        } catch { throw .overflow }
    }
}
