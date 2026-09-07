import Testing

import Division

@Suite("Division.Rounded")
struct NumericIntegerDivisionTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension NumericIntegerDivisionTests.Unit {
    @Test
    func `floor division of positive values`() throws {
        #expect(try Division.rounded(17, by: 5).quotient == 3)
        #expect(try Division.rounded(15, by: 5).quotient == 3)
    }

    @Test
    func `ceiling division of positive values`() throws {
        #expect(try Division.rounded(17, by: 5, rounding: .up).quotient == 4)
        #expect(try Division.rounded(15, by: 5, rounding: .up).quotient == 3)
    }

    @Test
    func `truncating division rounds toward zero`() throws {
        #expect(try Division.rounded(17, by: 5, rounding: .zero).quotient == 3)
        #expect(try Division.rounded((-17), by: 5, rounding: .zero).quotient == -3)
    }

    @Test
    func `division parts satisfy quotient times divisor plus remainder equals dividend`() throws {
        let (q, r) = try Division.rounded(17, by: 5)
        #expect(q == 3)
        #expect(r == 2)
        #expect(q * 5 + r == 17)
    }

    @Test
    func `bankers rounding ties to even`() throws {
        #expect(try Division.rounded(15, by: 10, rounding: .even).quotient == 2)
        #expect(try Division.rounded(25, by: 10, rounding: .even).quotient == 2)
        #expect(try Division.rounded(35, by: 10, rounding: .even).quotient == 4)
    }
}

extension NumericIntegerDivisionTests.EdgeCase {
    @Test
    func `floor division rounds toward negative infinity`() throws {
        #expect(try Division.rounded((-17), by: 5).quotient == -4)
        #expect(try Division.rounded(17, by: -5).quotient == -4)
        #expect(try Division.rounded((-17), by: -5).quotient == 3)
    }

    @Test
    func `ceiling division rounds toward positive infinity`() throws {
        #expect(try Division.rounded((-17), by: 5, rounding: .up).quotient == -3)
    }

    @Test
    func `division parts with negative dividend`() throws {
        let (q, r) = try Division.rounded((-17), by: 5)
        #expect(q == -4)
        #expect(r == 3)
        #expect(q * 5 + r == -17)
    }
}
