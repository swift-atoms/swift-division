# Division

Division owns integer division with explicit failure and rounding policies.

- `quotient(_:by:)` divides toward zero and reports quotient and remainder.
- `exact(_:by:)` requires a zero remainder.
- `euclidean(_:by:)` divides signed integers by a positive divisor, returning a
  nonnegative remainder smaller than the divisor.
- `Signed.euclidean(magnitude:polarity:by:)` performs Euclidean division on signed
  magnitudes while preserving the full unsigned storage range.

Zero divisors, negative divisors for Euclidean division, unrepresentable integer
quotients, and inexact division have distinct failures. The signed-magnitude
quotient has positive polarity for zero.

```swift
let result = try Division.euclidean(Int128(-61), by: 60)
// quotient: -2, remainder: 59
```

This operation defines a rounding policy and representation arithmetic. It does
not impose quantity domains; Ratio and other value domains own those bindings.
