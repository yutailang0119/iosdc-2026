import Foundation

package struct NativeBytebeatEvaluator: Sendable, BytebeatEvaluator {
  private let root: Expression

  package init(expression: String) throws {
    var parser = try Parser(source: expression)
    self.root = try parser.parse()
  }

  package func evaluate(t: UInt32) -> UInt8 {
    let value = root.evaluate(t: Double(t))
    return UInt8(truncatingIfNeeded: value.jsInt32)
  }
}

// MARK: - Expression tree

extension NativeBytebeatEvaluator {
  indirect enum Expression: Sendable {
    case number(Double)
    case time
    case unary(UnaryOperator, Expression)
    case binary(BinaryOperator, Expression, Expression)
    case ternary(condition: Expression, then: Expression, else: Expression)
    case call(BuiltinFunction, [Expression])
    case array([Expression])
    case element(array: Expression, index: Expression)

    func evaluate(t: Double) -> Double {
      switch self {
      case let .number(value):
        return value
      case .time:
        return t
      case let .unary(op, operand):
        return op.apply(operand.evaluate(t: t))
      case let .binary(op, lhs, rhs):
        switch op {
        case .logicalAnd:
          let left = lhs.evaluate(t: t)
          return left.isJSTruthy ? rhs.evaluate(t: t) : left
        case .logicalOr:
          let left = lhs.evaluate(t: t)
          return left.isJSTruthy ? left : rhs.evaluate(t: t)
        default:
          return op.apply(lhs.evaluate(t: t), rhs.evaluate(t: t))
        }
      case let .ternary(condition, then, alternative):
        return condition.evaluate(t: t).isJSTruthy
          ? then.evaluate(t: t)
          : alternative.evaluate(t: t)
      case let .call(function, arguments):
        return function.apply(arguments.map { $0.evaluate(t: t) })
      case let .array(elements):
        return switch elements.count {
        case 0: 0
        case 1: elements[0].evaluate(t: t)
        default: .nan
        }
      case let .element(array, index):
        let key = index.evaluate(t: t)
        guard case let .array(elements) = array,
          key >= 0,
          key == key.rounded(.towardZero),
          let i = Int(exactly: key),
          i < elements.count
        else {
          return .nan
        }
        return elements[i].evaluate(t: t)
      }
    }
  }
}

// MARK: - Operators

extension NativeBytebeatEvaluator {
  enum UnaryOperator: Sendable {
    case negate
    case plus
    case bitwiseNot
    case logicalNot

    func apply(_ a: Double) -> Double {
      switch self {
      case .negate: -a
      case .plus: a
      case .bitwiseNot: Double(~a.jsInt32)
      case .logicalNot: a.isJSTruthy ? 0 : 1
      }
    }
  }

  enum BinaryOperator: Sendable {
    case add
    case subtract
    case multiply
    case divide
    case remainder
    case exponent
    case bitwiseAnd
    case bitwiseOr
    case bitwiseXor
    case shiftLeft
    case shiftRight
    case unsignedShiftRight
    case lessThan
    case greaterThan
    case lessThanOrEqual
    case greaterThanOrEqual
    case equal
    case notEqual
    case logicalAnd
    case logicalOr
    case comma

    func apply(_ a: Double, _ b: Double) -> Double {
      switch self {
      case .add: return a + b
      case .subtract: return a - b
      case .multiply: return a * b
      case .divide: return a / b
      case .remainder: return a.truncatingRemainder(dividingBy: b)
      case .exponent: return a.jsPow(b)
      case .bitwiseAnd: return Double(a.jsInt32 & b.jsInt32)
      case .bitwiseOr: return Double(a.jsInt32 | b.jsInt32)
      case .bitwiseXor: return Double(a.jsInt32 ^ b.jsInt32)
      case .shiftLeft:
        let count = b.jsUInt32 & 31
        let shifted = UInt32(bitPattern: a.jsInt32) << count
        return Double(Int32(bitPattern: shifted))
      case .shiftRight: return Double(a.jsInt32 >> (b.jsUInt32 & 31))
      case .unsignedShiftRight: return Double(a.jsUInt32 >> (b.jsUInt32 & 31))
      case .lessThan: return a < b ? 1 : 0
      case .greaterThan: return a > b ? 1 : 0
      case .lessThanOrEqual: return a <= b ? 1 : 0
      case .greaterThanOrEqual: return a >= b ? 1 : 0
      case .equal: return a == b ? 1 : 0
      case .notEqual: return a != b ? 1 : 0
      case .comma: return b
      case .logicalAnd, .logicalOr: return 0
      }
    }
  }
}

// MARK: - Built-in Math functions

extension NativeBytebeatEvaluator {
  enum BuiltinFunction: String, Sendable {
    case sin
    case cos
    case tan
    case asin
    case acos
    case atan
    case atan2
    case sinh
    case cosh
    case tanh
    case asinh
    case acosh
    case atanh
    case floor
    case ceil
    case round
    case trunc
    case abs
    case sign
    case sqrt
    case cbrt
    case pow
    case hypot
    case exp
    case expm1
    case log
    case log1p
    case log2
    case log10
    case fround
    case clz32
    case imul
    case min
    case max

    func apply(_ arguments: [Double]) -> Double {
      func arg(_ index: Int) -> Double {
        index < arguments.count ? arguments[index] : .nan
      }
      switch self {
      case .sin: return Foundation.sin(arg(0))
      case .cos: return Foundation.cos(arg(0))
      case .tan: return Foundation.tan(arg(0))
      case .asin: return Foundation.asin(arg(0))
      case .acos: return Foundation.acos(arg(0))
      case .atan: return Foundation.atan(arg(0))
      case .atan2: return Foundation.atan2(arg(0), arg(1))
      case .sinh: return Foundation.sinh(arg(0))
      case .cosh: return Foundation.cosh(arg(0))
      case .tanh: return Foundation.tanh(arg(0))
      case .asinh: return Foundation.asinh(arg(0))
      case .acosh: return Foundation.acosh(arg(0))
      case .atanh: return Foundation.atanh(arg(0))
      case .floor: return arg(0).rounded(.down)
      case .ceil: return arg(0).rounded(.up)
      case .round: return (arg(0) + 0.5).rounded(.down)
      case .trunc: return arg(0).rounded(.towardZero)
      case .abs: return Swift.abs(arg(0))
      case .sign:
        let x = arg(0)
        return x > 0 ? 1 : (x < 0 ? -1 : x)
      case .sqrt: return Foundation.sqrt(arg(0))
      case .cbrt: return Foundation.cbrt(arg(0))
      case .pow: return arg(0).jsPow(arg(1))
      case .hypot: return Foundation.hypot(arg(0), arg(1))
      case .exp: return Foundation.exp(arg(0))
      case .expm1: return Foundation.expm1(arg(0))
      case .log: return Foundation.log(arg(0))
      case .log1p: return Foundation.log1p(arg(0))
      case .log2: return Foundation.log2(arg(0))
      case .log10: return Foundation.log10(arg(0))
      case .fround: return Double(Float(arg(0)))
      case .clz32: return Double(arg(0).jsUInt32.leadingZeroBitCount)
      case .imul:
        let product = UInt32(bitPattern: arg(0).jsInt32) &* UInt32(bitPattern: arg(1).jsInt32)
        return Double(Int32(bitPattern: product))
      case .min: return arguments.isEmpty ? .infinity : arguments.reduce(Double.infinity, Swift.min)
      case .max: return arguments.isEmpty ? -.infinity : arguments.reduce(-Double.infinity, Swift.max)
      }
    }
  }
}

// MARK: - Parsing

extension NativeBytebeatEvaluator {
  enum ParseError: Error, CustomStringConvertible {
    case unexpectedCharacter(Character)
    case invalidNumber(String)
    case unexpectedToken(String)
    case unexpectedEnd
    case expected(String)
    case unknownIdentifier(String)

    var description: String {
      switch self {
      case let .unexpectedCharacter(character):
        return "Unexpected character '\(character)'."
      case let .invalidNumber(text):
        return "Invalid number literal '\(text)'."
      case let .unexpectedToken(text):
        return "Unexpected token '\(text)'."
      case .unexpectedEnd:
        return "Unexpected end of expression."
      case let .expected(text):
        return "Expected '\(text)'."
      case let .unknownIdentifier(name):
        return "Unknown identifier '\(name)'."
      }
    }
  }

  private enum Token {
    case number(Double)
    case identifier(String)
    case symbol(String)
  }

  private struct Parser {
    private let tokens: [Token]
    private var position = 0

    init(source: String) throws {
      self.tokens = try Parser.tokenize(source)
    }

    // MARK: Tokenizer

    private static func tokenize(_ source: String) throws -> [Token] {
      var tokens: [Token] = []
      let characters = Array(source)
      let count = characters.count
      var index = 0

      let threeCharSymbols = [">>>", "===", "!=="]
      let twoCharSymbols = ["<<", ">>", "<=", ">=", "==", "!=", "&&", "||", "**"]
      let oneCharSymbols = Set("+-*/%&|^~<>!?:(),.[]")

      func matches(_ symbol: String, at start: Int) -> Bool {
        let length = symbol.count
        guard start + length <= count else { return false }
        return String(characters[start..<(start + length)]) == symbol
      }

      while index < count {
        let character = characters[index]

        if character.isWhitespace {
          index += 1
          continue
        }

        if character.isNumber
          || (character == "." && index + 1 < count && characters[index + 1].isNumber)
        {
          if character == "0", index + 1 < count {
            let prefix = characters[index + 1]
            let radix: Int? =
              (prefix == "x" || prefix == "X")
              ? 16
              : (prefix == "b" || prefix == "B")
                ? 2 : (prefix == "o" || prefix == "O") ? 8 : nil
            if let radix {
              var end = index + 2
              while end < count, characters[end].isHexDigit || characters[end] == "_" {
                end += 1
              }
              let digits = String(characters[(index + 2)..<end]).filter { $0 != "_" }
              guard let value = UInt64(digits, radix: radix) else {
                throw ParseError.invalidNumber(String(characters[index..<end]))
              }
              tokens.append(.number(Double(value)))
              index = end
              continue
            }
          }

          var end = index
          while end < count,
            characters[end].isNumber || characters[end] == "." || characters[end] == "_"
          {
            end += 1
          }
          if end < count, characters[end] == "e" || characters[end] == "E" {
            end += 1
            if end < count, characters[end] == "+" || characters[end] == "-" {
              end += 1
            }
            while end < count, characters[end].isNumber || characters[end] == "_" {
              end += 1
            }
          }
          let text = String(characters[index..<end]).filter { $0 != "_" }
          guard let value = Double(text) else {
            throw ParseError.invalidNumber(String(characters[index..<end]))
          }
          tokens.append(.number(value))
          index = end
          continue
        }

        if character.isLetter || character == "_" || character == "$" {
          var end = index
          while end < count {
            let scalar = characters[end]
            guard scalar.isLetter || scalar.isNumber || scalar == "_" || scalar == "$" else {
              break
            }
            end += 1
          }
          tokens.append(.identifier(String(characters[index..<end])))
          index = end
          continue
        }

        if let symbol = threeCharSymbols.first(where: { matches($0, at: index) }) {
          tokens.append(.symbol(symbol))
          index += 3
          continue
        }
        if let symbol = twoCharSymbols.first(where: { matches($0, at: index) }) {
          tokens.append(.symbol(symbol))
          index += 2
          continue
        }
        if oneCharSymbols.contains(character) {
          tokens.append(.symbol(String(character)))
          index += 1
          continue
        }

        throw ParseError.unexpectedCharacter(character)
      }

      return tokens
    }

    // MARK: Cursor helpers

    private func peek() -> Token? {
      position < tokens.count ? tokens[position] : nil
    }

    private mutating func consume(symbol: String) -> Bool {
      if case let .symbol(value)? = peek(), value == symbol {
        position += 1
        return true
      }
      return false
    }

    private mutating func expect(symbol: String) throws {
      guard consume(symbol: symbol) else {
        throw ParseError.expected(symbol)
      }
    }

    private mutating func parseBinary(
      operators: [String: BinaryOperator],
      next: (inout Parser) throws -> Expression
    ) throws -> Expression {
      var left = try next(&self)
      while case let .symbol(symbol)? = peek(), let op = operators[symbol] {
        position += 1
        let right = try next(&self)
        left = .binary(op, left, right)
      }
      return left
    }

    // MARK: Grammar (lowest to highest precedence)

    mutating func parse() throws -> Expression {
      let expression = try parseSequence()
      if let token = peek() {
        throw ParseError.unexpectedToken(Parser.describe(token))
      }
      return expression
    }

    private mutating func parseSequence() throws -> Expression {
      var expression = try parseExpression()
      while consume(symbol: ",") {
        let next = try parseExpression()
        expression = .binary(.comma, expression, next)
      }
      return expression
    }

    private mutating func parseExpression() throws -> Expression {
      try parseTernary()
    }

    private mutating func parseTernary() throws -> Expression {
      let condition = try parseLogicalOr()
      guard consume(symbol: "?") else { return condition }
      let then = try parseTernary()
      try expect(symbol: ":")
      let alternative = try parseTernary()
      return .ternary(condition: condition, then: then, else: alternative)
    }

    private mutating func parseLogicalOr() throws -> Expression {
      try parseBinary(operators: ["||": .logicalOr]) { try $0.parseLogicalAnd() }
    }

    private mutating func parseLogicalAnd() throws -> Expression {
      try parseBinary(operators: ["&&": .logicalAnd]) { try $0.parseBitwiseOr() }
    }

    private mutating func parseBitwiseOr() throws -> Expression {
      try parseBinary(operators: ["|": .bitwiseOr]) { try $0.parseBitwiseXor() }
    }

    private mutating func parseBitwiseXor() throws -> Expression {
      try parseBinary(operators: ["^": .bitwiseXor]) { try $0.parseBitwiseAnd() }
    }

    private mutating func parseBitwiseAnd() throws -> Expression {
      try parseBinary(operators: ["&": .bitwiseAnd]) { try $0.parseEquality() }
    }

    private mutating func parseEquality() throws -> Expression {
      try parseBinary(operators: [
        "==": .equal, "!=": .notEqual, "===": .equal, "!==": .notEqual,
      ]) { try $0.parseRelational() }
    }

    private mutating func parseRelational() throws -> Expression {
      try parseBinary(operators: [
        "<": .lessThan, ">": .greaterThan,
        "<=": .lessThanOrEqual, ">=": .greaterThanOrEqual,
      ]) { try $0.parseShift() }
    }

    private mutating func parseShift() throws -> Expression {
      try parseBinary(operators: [
        "<<": .shiftLeft, ">>": .shiftRight, ">>>": .unsignedShiftRight,
      ]) { try $0.parseAdditive() }
    }

    private mutating func parseAdditive() throws -> Expression {
      try parseBinary(operators: ["+": .add, "-": .subtract]) { try $0.parseMultiplicative() }
    }

    private mutating func parseMultiplicative() throws -> Expression {
      try parseBinary(operators: [
        "*": .multiply, "/": .divide, "%": .remainder,
      ]) { try $0.parseExponentiation() }
    }

    private mutating func parseExponentiation() throws -> Expression {
      if case let .symbol(symbol)? = peek(), Parser.unaryOperators[symbol] != nil {
        return try parseUnary()
      }
      let base = try parsePostfix()
      guard consume(symbol: "**") else { return base }
      return .binary(.exponent, base, try parseExponentiation())
    }

    private static let unaryOperators: [String: UnaryOperator] = [
      "-": .negate, "+": .plus, "~": .bitwiseNot, "!": .logicalNot,
    ]

    private mutating func parseUnary() throws -> Expression {
      if case let .symbol(symbol)? = peek(), let op = Parser.unaryOperators[symbol] {
        position += 1
        return .unary(op, try parseUnary())
      }
      return try parsePostfix()
    }

    private mutating func parsePrimary() throws -> Expression {
      guard let token = peek() else { throw ParseError.unexpectedEnd }
      switch token {
      case let .number(value):
        position += 1
        return .number(value)
      case let .identifier(name):
        position += 1
        return try parseIdentifier(name)
      case let .symbol(symbol):
        switch symbol {
        case "(":
          position += 1
          let expression = try parseSequence()
          try expect(symbol: ")")
          return expression
        case "[":
          return try parseArrayLiteral()
        default:
          throw ParseError.unexpectedToken(symbol)
        }
      }
    }

    private mutating func parseArrayLiteral() throws -> Expression {
      try expect(symbol: "[")
      var elements: [Expression] = []
      if consume(symbol: "]") {
        return .array(elements)
      }
      repeat {
        elements.append(try parseExpression())
      } while consume(symbol: ",")
      try expect(symbol: "]")
      return .array(elements)
    }

    private mutating func parsePostfix() throws -> Expression {
      var expression = try parsePrimary()
      while consume(symbol: "[") {
        let index = try parseExpression()
        try expect(symbol: "]")
        expression = .element(array: expression, index: index)
      }
      return expression
    }

    private mutating func parseIdentifier(_ name: String) throws -> Expression {
      if name == "t" {
        return .time
      }
      guard name == "Math" else {
        throw ParseError.unknownIdentifier(name)
      }
      try expect(symbol: ".")
      guard case let .identifier(member)? = peek() else {
        throw ParseError.expected("Math member")
      }
      position += 1

      if let constant = Parser.mathConstants[member] {
        return .number(constant)
      }
      guard let function = BuiltinFunction(rawValue: member) else {
        throw ParseError.unknownIdentifier("Math.\(member)")
      }
      let arguments = try parseArgumentList()
      return .call(function, arguments)
    }

    private mutating func parseArgumentList() throws -> [Expression] {
      try expect(symbol: "(")
      var arguments: [Expression] = []
      if consume(symbol: ")") {
        return arguments
      }
      repeat {
        arguments.append(try parseExpression())
      } while consume(symbol: ",")
      try expect(symbol: ")")
      return arguments
    }

    private static let mathConstants: [String: Double] = [
      "PI": .pi,
      "E": M_E,
      "LN2": M_LN2,
      "LN10": M_LN10,
      "LOG2E": M_LOG2E,
      "LOG10E": M_LOG10E,
      "SQRT2": 2.0.squareRoot(),
      "SQRT1_2": 0.5.squareRoot(),
    ]

    private static func describe(_ token: Token) -> String {
      switch token {
      case let .number(value): "\(value)"
      case let .identifier(name): name
      case let .symbol(symbol): symbol
      }
    }
  }
}

private extension Double {
  private static let modulus = exp2(32.0)  // 2^32

  var isJSTruthy: Bool {
    self != 0 && !isNaN
  }

  var jsInt32: Int32 {
    guard isFinite else { return 0 }
    let truncated = rounded(.towardZero).truncatingRemainder(dividingBy: Self.modulus)
    var wrapped = truncated < 0 ? truncated + Self.modulus : truncated
    if wrapped >= Self.modulus / 2 { wrapped -= Self.modulus }
    return Int32(wrapped)
  }

  var jsUInt32: UInt32 {
    guard isFinite else { return 0 }
    let truncated = rounded(.towardZero).truncatingRemainder(dividingBy: Self.modulus)
    let wrapped = truncated < 0 ? truncated + Self.modulus : truncated
    return UInt32(wrapped)
  }

  func jsPow(_ exponent: Double) -> Double {
    if exponent.isNaN { return .nan }
    if Swift.abs(self) == 1 && exponent.isInfinite { return .nan }
    return Foundation.pow(self, exponent)
  }
}
