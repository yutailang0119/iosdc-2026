final class BytebeatDSP: @unchecked Sendable {
  private let step: UInt64
  private var accumulator: UInt64
  private let mixer: BytebeatMixer
  private var held: Float

  init(sampleRate: Double) {
    let sampleRate = sampleRate > 0 ? sampleRate : 44100
    let ratio = 8000.0 / sampleRate
    self.step = UInt64(ratio * Double(UInt64(1) << 32))
    self.accumulator = 0
    self.mixer = BytebeatMixer()
    self.held = 0
  }

  @inline(__always)
  func refresh() {
    if mixer.refresh() {
      held = mixer.sample(t: UInt32(accumulator >> 32))
    }
  }

  @inline(__always)
  func evaluate() -> (sample: Float, isNewStep: Bool) {
    let previous = UInt32(accumulator >> 32)
    accumulator &+= step
    let t = UInt32(accumulator >> 32)
    let isNewStep = t != previous
    if isNewStep {
      held = mixer.sample(t: t)
    }
    return (held, isNewStep)
  }

  func setEvaluator(_ evaluator: any BytebeatEvaluator) {
    mixer.setEvaluator(evaluator)
  }
}
