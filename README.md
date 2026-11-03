# swift-division

Use this package to divide fixed-width integers without trapping: every case where Swift's `/` and `%` would trap or lose information comes back as a typed failure. Start from `Division.quotient` for truncating division, `Division.exact` when the divisor must divide evenly, `Division.euclidean` for a remainder that is never negative, `Division.rounded` to pick the quotient's direction with a `Rounding` rule, and `Division.Signed.euclidean` when the dividend is held as a magnitude plus a `Polarity`. The rounding rules come from the sibling swift-rounding package.

## Laws

- Every result satisfies `quotient * divisor + remainder == dividend`, whichever rule produced it.
- `Division.quotient` truncates toward zero, so its remainder takes the dividend's sign.
- `Division.euclidean` and `Division.Signed.euclidean` return a remainder in `0..<divisor`, so the quotient is the floor. `Division.euclidean` refuses a negative divisor rather than choosing a convention for it.
- `Division.Signed.euclidean` covers the whole unsigned range of the magnitude in both polarities, and a zero quotient always comes back with `Polarity.positive`, never a negative zero.
- `Division.rounded` defaults to `Rounding.down` (floor). It only changes the quotient when there is a remainder. A tie is a remainder whose magnitude equals half the divisor's magnitude, and the rule decides it. The remainder is whatever satisfies the identity above, so its sign depends on the rule and on the operands' signs. For a positive divisor, `Rounding.down` gives the same result as `Division.euclidean`.
- Failures: a zero divisor fails with `Division.Error.zero` in every operation. The minimum value divided by `-1` fails with `Division.Error.overflow`. A nonzero remainder fails with `Division.Error.inexact` in `Division.exact`, and in `Division.rounded` under `Rounding.exact`.
