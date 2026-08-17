import AVFoundation
import Synchronization

package final class BytebeatEngine: @unchecked Sendable {
  private let engine: AVAudioEngine
  private let lock: Mutex<Void>
  private let dsp: BytebeatDSP
  private let buffer: WaveformBuffer

  package init() {
    let engine = AVAudioEngine()
    let format = engine.outputNode.outputFormat(forBus: 0)
    self.engine = engine
    self.lock = Mutex<Void>(())
    self.dsp = BytebeatDSP(sampleRate: format.sampleRate)
    self.buffer = WaveformBuffer(size: 2048)

    let buffer = self.buffer
    let dsp = self.dsp
    let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
      dsp.refresh()
      let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
      for frame in 0..<Int(frameCount) {
        let (sample, isNewStep) = dsp.evaluate()
        if isNewStep {
          buffer.push(sample)
        }
        for buffer in buffers {
          if let pointer = buffer.mData?.assumingMemoryBound(to: Float.self) {
            pointer[frame] = sample
          }
        }
      }
      return noErr
    }
    engine.attach(source)
    engine.connect(source, to: engine.mainMixerNode, format: format)
  }

  func setEvaluators(_ evaluators: [any BytebeatEvaluator]) {
    dsp.setEvaluators(evaluators)
  }

  func start() throws {
    try lock.withLock { _ in
      #if !os(macOS)
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback)
      try session.setActive(true)
      #endif
      try engine.start()
    }
  }

  func stop() {
    lock.withLock { _ in
      engine.stop()
      #if !os(macOS)
      try? AVAudioSession.sharedInstance().setActive(
        false,
        options: .notifyOthersOnDeactivation
      )
      #endif
    }
  }

  var isRunning: Bool {
    lock.withLock { _ in
      engine.isRunning
    }
  }

  var waveform: AsyncStream<WaveformSnapshot> {
    let buffer = self.buffer
    return AsyncStream { continuation in
      let task = Task {
        while !Task.isCancelled {
          continuation.yield(buffer.snapshot())
          try await Task.sleep(for: .milliseconds(16))
        }
      }
      continuation.onTermination = { _ in
        task.cancel()
      }
    }
  }
}
