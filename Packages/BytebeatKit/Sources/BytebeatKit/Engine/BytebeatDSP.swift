final class BytebeatDSP: @unchecked Sendable {
  private let step: UInt64
  private var accumulator: UInt64
  private let mixer: BytebeatMixer

  init(sampleRate: Double) {
    let sampleRate = sampleRate > 0 ? sampleRate : 44100
    let ratio = 8000.0 / sampleRate
    self.step = UInt64(ratio * Double(UInt64(1) << 32))
    self.accumulator = 0
    self.mixer = BytebeatMixer()
  }

  @inline(__always)
  func refresh() {
    mixer.refresh()
  }

  @inline(__always)
  func evaluate() -> (sample: Float, isNewStep: Bool) {
    let previous = UInt32(accumulator >> 32)
    accumulator &+= step
    let t = UInt32(accumulator >> 32)
    return (mixer.sample(t: t), t != previous)
  }

  func setEvaluators(_ evaluators: [any BytebeatEvaluator]) {
    mixer.setEvaluators(evaluators)
  }
}
