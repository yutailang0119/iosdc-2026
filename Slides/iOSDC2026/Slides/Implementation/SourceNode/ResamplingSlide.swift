//
//  ResamplingSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/25.
//

import SlideKit
import SwiftUI

@Slide
struct ResamplingSlide: View {
  var body: some View {
    HeaderSlide("8,000Hz → 48,000Hz") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    """
    let ratio = 8000.0 / sampleRate
    let step = UInt64(ratio * Double(UInt64(1) << 32))
    var accumulator: UInt64 = 0

    func evaluate() -> Float {
      accumulator &+= step
      let t = UInt32(accumulator >> 32)
      return mixer.sample(t: t)
    }
    """
  }

  var script: String {
    """
    Bytebeatは8,000Hz前提ですが、出力は48,000Hzです
    tを1つずつ進めると6倍速、音程が6倍高くなります
    そこで比率を32.32の固定小数点でstepとして持って、accumulatorに足していきます
    上位32ビットを取り出したものがtなので、6サンプルに1回だけtが進みます
    Doubleを持ち回らず整数の加算だけで済むので、オーディオスレッドでも安全です
    """
  }
}

#Preview {
  SlidePreview {
    ResamplingSlide()
  }
}
