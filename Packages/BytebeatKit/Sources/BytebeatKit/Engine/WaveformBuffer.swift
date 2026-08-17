import Synchronization

final class WaveformBuffer: @unchecked Sendable {
  private let storage: UnsafeMutableBufferPointer<Float>
  private let writeIndex: Atomic<Int>
  private let totalCount: Atomic<Int>

  init(size: Int) {
    let pointer = UnsafeMutableBufferPointer<Float>.allocate(capacity: size)
    pointer.initialize(repeating: 0)
    self.storage = pointer
    self.writeIndex = Atomic<Int>(0)
    self.totalCount = Atomic<Int>(0)
  }

  deinit {
    storage.deinitialize()
    storage.deallocate()
  }

  @inline(__always)
  func push(_ sample: Float) {
    let i = writeIndex.load(ordering: .relaxed)
    storage[i] = sample
    writeIndex.store((i + 1) % storage.count, ordering: .releasing)
    totalCount.wrappingAdd(1, ordering: .relaxed)
  }

  func snapshot() -> WaveformSnapshot {
    let total = totalCount.load(ordering: .acquiring)
    let head = writeIndex.load(ordering: .acquiring)
    let n = storage.count
    var out = [Float](repeating: 0, count: n)
    for k in 0..<n {
      out[k] = storage[(head + k) % n]
    }
    return WaveformSnapshot(
      samples: out,
      totalCount: total
    )
  }
}
