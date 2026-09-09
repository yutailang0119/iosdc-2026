import Testing

@testable import BytebeatKit

struct SwiftEvaluatorTests {
  @Test(
    arguments: [
      ("1+2*3", 7),
      ("(1+2)*3", 9),
      ("7/2", 3),
      ("1/0", 0),
      ("0/0", 0),
      ("-7%3", 255),
      ("-1&255", 255),
      ("255^170", 85),
      ("12|3", 15),
      ("~0", 255),
      ("1<<33", 2),
      ("256>>4", 16),
      ("-1>>>28", 15),
      ("5>3", 1),
      ("5<3", 0),
      ("3<=3", 1),
      ("4==4", 1),
      ("4!==4", 0),
      ("0||5", 5),
      ("3&&7", 7),
      ("0&&7", 0),
      ("!5", 0),
      ("!0", 1),
      ("0xFF", 255),
      ("1e2", 100),
      (".5*2", 1),
      ("2147483648|0", 0),
      ("4294967299|0", 3),
      ("Math.round(1.5)", 2),
      ("Math.round(-1.5)", 255),
      ("Math.floor(1.9)", 1),
      ("Math.ceil(1.1)", 2),
      ("Math.abs(-3)", 3),
      ("Math.min(3,1,2)", 1),
      ("Math.max(3,1,2)", 3),
      ("Math.pow(2,8)%255", 1),
      ("Math.sqrt(81)", 9),
      ("Math.PI", 3),
      ("[10,20,30][1]", 20),
      ("[7][0]", 7),
      ("[][0]", 0),
      ("[1,2][5]", 0),
      ("0b1010", 10),
      ("0o17", 15),
      ("0xFF_FF&255", 255),
      ("1_000%256", 232),
      ("(1,2,3)", 3),
      ("Math.imul(3,5)", 15),
      ("Math.clz32(1)", 31),
      ("Math.fround(0.5)", 0),
      ("a=5", 5),
      ("a=5,a*2", 10),
      ("a=5,a+=1", 6),
      ("a=7,a%=4", 3),
      ("a=2,a**=3", 8),
      ("a=1,a<<=4", 16),
      ("a=-1,a>>>=28", 15),
      ("a=12,a&=10", 8),
      ("a=12,a|=3", 15),
      ("a=12,a^=10", 6),
      ("a=5,b=3,a*b", 15),
      ("a=b=4,a+b", 8),
      ("t=9,t", 9),
      ("(a)=6,a", 6),
    ] as [(String, UInt8)]
  )
  func evaluatesConstantExpression(_ testCase: (String, UInt8)) throws {
    let evaluator = try SwiftEvaluator(expression: testCase.0)
    #expect(evaluator.evaluate(t: 0) == testCase.1)
  }

  @Test(
    arguments: [
      ("t", 300, 44),
      ("t?7:9", 0, 9),
      ("t?7:9", 3, 7),
      ("t>>>4", 255, 15),
      ("t*(42&t>>10)", 4000, 64),
      ("t%=256,t", 300, 44),
      ("a=t>>4,a*a", 64, 16),
    ] as [(String, UInt32, UInt8)]
  )
  func evaluatesTimeDependentExpression(_ testCase: (String, UInt32, UInt8)) throws {
    let evaluator = try SwiftEvaluator(expression: testCase.0)
    #expect(evaluator.evaluate(t: testCase.1) == testCase.2)
  }

  @Test func exponentiationIsRightAssociative() throws {
    let evaluator = try SwiftEvaluator(expression: "2**1**2")
    #expect(evaluator.evaluate(t: 0) == 2)
  }

  @Test func exponentiationBindsTighterThanMultiplication() throws {
    let evaluator = try SwiftEvaluator(expression: "t*t**2")
    #expect(evaluator.evaluate(t: 3) == 27)
  }

  @Test func exponentiationAcceptsUnaryExponent() throws {
    let evaluator = try SwiftEvaluator(expression: "2**-1")
    #expect(evaluator.evaluate(t: 0) == 0)
  }

  @Test func exponentiationAcceptsParenthesizedUnaryBase() throws {
    let evaluator = try SwiftEvaluator(expression: "(-2)**2")
    #expect(evaluator.evaluate(t: 0) == 4)
  }

  @Test(
    arguments: [
      "t*(42&t>>10)",
      "t*(t>>5|t>>8)",
      "t*3&t>>5",
      "t*(t>>9|t>>13)&16",
      "t*(0xCA&t>>9)",
      "128+127*Math.sin(t/10)",
      "t**2%255",
      "t*[1,2,3,4][t>>8&3]>>4",
      "128+127*Math.tanh(t/9999)",
      "Math.imul(t,3)&255",
      "(t>>10&1&&(t>>12&3)<3)?t>>4:t*(t>>9&1?3:5)&t>>(t>>11&1?4:6)",
      "t%=4096,t*(t>>5|t>>8)",
      "a=t>>6,b=t>>8,t*(a^b)&127",
      "a=t,a%=64,a*4",
      "t=t>>1,t*3&t>>5",
    ]
  )
  func matchesJavaScriptCoreEvaluator(expression: String) throws {
    let swift = try SwiftEvaluator(expression: expression)
    let javaScriptCore = try JavaScriptCoreEvaluator(expression: expression)
    for t in stride(from: UInt32(0), to: 65536, by: 127) {
      #expect(swift.evaluate(t: t) == javaScriptCore.evaluate(t: t), "t=\(t)")
    }
  }

  @Test(
    arguments: [
      "",
      "(t",
      "t+",
      "t 2",
      "x",
      "T",
      "Math.foo(1)",
      "1..2",
      "0x",
      "-2**2",
      "5=t",
      "t+1=2",
      "Math.PI=3",
      "a=1,b",
      "a+=1",
      "a*=2,a=1",
      "t++",
      "--t",
      "a=1,a++ +2",
      "t--1",
    ]
  )
  func rejectsInvalidExpression(_ expression: String) {
    #expect(throws: (any Error).self) {
      _ = try SwiftEvaluator(expression: expression)
    }
  }

  @Test func reportsFirstUnknownIdentifier() {
    #expect {
      _ = try SwiftEvaluator(expression: "x+y")
    } throws: { error in
      String(describing: error) == "Unknown identifier 'x'."
    }
  }
}
