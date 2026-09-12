import Synchronization

final class BytebeatMixer: @unchecked Sendable {
  private struct Voice {
    let evaluator: any BytebeatEvaluator

    @inline(__always)
    func sample(t: UInt32) -> Float {
      let byte = evaluator.evaluate(t: t)
      return Float(byte) * (1.0 / 128.0) - 1.0
    }
  }

  private struct Exchange {
    var pending: Voice?
    var retired: Voice?
  }

  private let exchange = Mutex<Exchange>(Exchange())
  private var voice: Voice?

  func setEvaluator(_ evaluator: any BytebeatEvaluator) {
    let voice = Voice(evaluator: evaluator)
    exchange.withLock {
      $0.pending = voice
      $0.retired = nil
    }
  }

  @inline(__always)
  func refresh() -> Bool {
    exchange.withLockIfAvailable { exchange in
      guard let pending = exchange.pending else { return false }
      exchange.pending = nil
      exchange.retired = voice
      voice = pending
      return true
    } ?? false
  }

  @inline(__always)
  func sample(t: UInt32) -> Float {
    guard let voice else { return 0 }
    return voice.sample(t: t)
  }
}
