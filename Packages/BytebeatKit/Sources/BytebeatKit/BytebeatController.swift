import SwiftUI

@Observable
@MainActor
public final class BytebeatController {
  private let engine: BytebeatEngine
  private(set) var expressions: [Expression]
  private(set) var isPlaying: Bool

  private let scopeColumnCount = 1024
  private let samplesPerColumn = 32
  private(set) var scope: [ScopeColumn]
  private(set) var scopeCursor: Int
  private var scopeWritingColumn: Int
  private var processedCount: Int
  private var waveformTask: Task<Void, Never>?

  public init() {
    self.engine = BytebeatEngine()
    self.expressions = []
    self.isPlaying = false
    self.scope = Array(
      repeating: ScopeColumn(min: 0, max: 0),
      count: 1024
    )
    self.scopeCursor = 0
    self.scopeWritingColumn = -1
    self.processedCount = 0
  }

  public func toggle() throws {
    if isPlaying {
      engine.stop()
      waveformTask?.cancel()
      waveformTask = nil
      isPlaying = false
    } else {
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
  }

  public func add(expression: String) throws {
    let evaluator = try NativeBytebeatEvaluator(
      expression: expression
    )
    expressions.append(
      Expression(raw: expression, evaluator: evaluator)
    )
    engine.setEvaluators(expressions.map(\.evaluator))
  }

  public func remove(at offsets: IndexSet) {
    expressions.remove(atOffsets: offsets)
    engine.setEvaluators(expressions.map(\.evaluator))
  }

  public func removeAll() {
    expressions.removeAll()
    engine.setEvaluators(expressions.map(\.evaluator))
  }
}

extension BytebeatController {
  struct Expression: Identifiable {
    let id = UUID()
    var raw: String
    var evaluator: any BytebeatEvaluator
  }

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
