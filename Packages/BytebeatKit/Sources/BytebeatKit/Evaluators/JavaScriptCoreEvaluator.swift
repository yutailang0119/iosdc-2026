import JavaScriptCore

package struct JavaScriptCoreEvaluator: @unchecked Sendable, BytebeatEvaluator {
  private let context: JSContext
  private let function: JSValue

  package init(expression: String) throws {
    guard let context = JSContext() else {
      throw JavaScriptError.contextCreationFailed
    }

    let script = """
      var bytebeat = function(t) {
          return (\(expression));
      }
      """
    context.evaluateScript(script)
    if let exception = context.exception {
      throw JavaScriptError.evaluationFailed(
        message: exception.toString()
      )
    }

    guard let function = context.objectForKeyedSubscript("bytebeat"),
      function.isObject
    else {
      throw JavaScriptError.undefinedIdentifier(name: "bytebeat")
    }

    self.context = context
    self.function = function
  }

  package func evaluate(t: UInt32) -> UInt8 {
    context.exception = nil
    guard let result = function.call(withArguments: [Double(t)]),
      !result.isUndefined,
      !result.isNull,
      context.exception == nil
    else {
      context.exception = nil
      return 0
    }
    return UInt8(truncatingIfNeeded: result.toInt32())
  }
}

extension JavaScriptCoreEvaluator {
  enum JavaScriptError: Error {
    case contextCreationFailed
    case undefinedIdentifier(name: String)
    case evaluationFailed(message: String)
  }
}
