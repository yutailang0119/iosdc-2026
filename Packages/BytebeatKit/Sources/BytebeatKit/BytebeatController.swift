import SwiftUI

@Observable
@MainActor
public final class BytebeatController {
  private let engine: BytebeatEngine
  package private(set) var isPlaying: Bool

  private let scopeColumnCount: Int
  private let samplesPerColumn: Int
  private(set) var scope: [ScopeColumn]
  private(set) var scopeCursor: Int
  private var scopeWritingColumn: Int
  private var processedCount: Int
  private var waveformTask: Task<Void, Never>?

  public init(
    scopeColumnCount: Int = 1024,
    samplesPerColumn: Int = 32
  ) {
    let scopeColumnCount = max(1, scopeColumnCount)
    let samplesPerColumn = max(1, samplesPerColumn)
    self.engine = BytebeatEngine()
    self.isPlaying = false
    self.scopeColumnCount = scopeColumnCount
    self.samplesPerColumn = samplesPerColumn
    self.scope = Array(
      repeating: ScopeColumn(min: 0, max: 0),
      count: scopeColumnCount
    )
    self.scopeCursor = 0
    self.scopeWritingColumn = -1
    self.processedCount = 0
  }

  public func play(expression: String) throws {
    let evaluator = try SwiftEvaluator(
      expression: expression
    )
    engine.setEvaluator(evaluator)

    guard !isPlaying else { return }
    try engine.start()
    let stream = engine.waveform
    waveformTask = Task { [weak self] in
      for await snapshot in stream {
        guard let self else { break }
        guard self.engine.isRunning else {
          self.isPlaying = false
          self.waveformTask = nil
          break
        }
        self.consume(snapshot)
      }
    }
    isPlaying = true
  }

  public func stop() {
    engine.stop()
    waveformTask?.cancel()
    waveformTask = nil
    isPlaying = false
  }
}

extension BytebeatController {
  struct ScopeColumn {
    var min: Float
    var max: Float
  }
}

private extension BytebeatController {
  func consume(_ snapshot: WaveformSnapshot) {
    let samples = snapshot.samples
    let n = samples.count
    guard n > 0 else { return }

    let total = snapshot.totalCount
    let firstAbsolute = total - n
    let startIndex = max(0, processedCount - firstAbsolute)
    guard startIndex < n else {
      processedCount = total
      return
    }

    var columns = scope
    var column = scopeWritingColumn
    for k in startIndex..<n {
      let absolute = firstAbsolute + k
      guard absolute >= 0 else { continue }
      let target = (absolute / samplesPerColumn) % scopeColumnCount
      let value = samples[k]
      if target != column {
        columns[target] = ScopeColumn(min: value, max: value)
        column = target
      } else {
        columns[target].min = Swift.min(columns[target].min, value)
        columns[target].max = Swift.max(columns[target].max, value)
      }
    }
    scope = columns
    scopeWritingColumn = column
    scopeCursor = column
    processedCount = total
  }
}
