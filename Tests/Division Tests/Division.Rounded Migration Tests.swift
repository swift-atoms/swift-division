import Testing

import Division

@Suite
struct `Integer division applies rounding policies` {
    @Suite struct `Division preserves quotient remainder and rounding relationships` {}
    @Suite struct `Negative operands follow the requested rounding direction` {}
    @Suite struct `No integration cases are defined` {}
    @Suite(.serialized) struct `No performance cases are defined` {}
}

extension `Integer division applies rounding policies`.`Division preserves quotient remainder and rounding relationships` {
    @Test
    func `Floor division rounds positive quotients down`() throws {
        #expect(try Division.rounded(17, by: 5).quotient == 3)
        #expect(try Division.rounded(15, by: 5).quotient == 3)
    }

    @Test
    func `Ceiling division rounds positive quotients up`() throws {
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

extension `Integer division applies rounding policies`.`Negative operands follow the requested rounding direction` {
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
    func `Negative dividends produce a nonnegative Euclidean remainder`() throws {
        let (q, r) = try Division.rounded((-17), by: 5)
        #expect(q == -4)
        #expect(r == 3)
        #expect(q * 5 + r == -17)
    }
}
