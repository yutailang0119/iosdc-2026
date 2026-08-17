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
    var pending: [Voice]?
    var retired: [Voice]?
  }

  private let exchange = Mutex<Exchange>(Exchange())
  private var voices: [Voice] = []

  func setEvaluators(_ evaluators: [any BytebeatEvaluator]) {
    let voices = evaluators.map(Voice.init(evaluator:))
    exchange.withLock {
      $0.pending = voices
      $0.retired = nil
    }
  }

  @inline(__always)
  func refresh() {
    exchange.withLockIfAvailable { exchange in
      guard let pending = exchange.pending else { return }
      exchange.pending = nil
      exchange.retired = voices
      voices = pending
    }
  }

  @inline(__always)
  func sample(t: UInt32) -> Float {
    var mix: Float = 0
    for voice in voices {
      mix += voice.sample(t: t)
    }
    return mix / (1 + abs(mix))
  }
}
