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
    HeaderSlide("8,000Hz → sampleRate") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    """
    let format = engine.outputNode.outputFormat(forBus: 0)
    let sampleRate = format.sampleRate

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
    Bytebeatは8,000Hzですが、出力レートはデバイスによって変わるので、outputFormatから受け取ります
    出力の方が高いので、tを1つずつ進めると早送りになって、音程も上がります
    そこで比率を32.32の固定小数点でstepとして持って、accumulatorに足していきます
    上位32ビットを取り出したものがtなので、数サンプルに1回だけtが進みます
    Doubleを持ち回らず整数の加算だけで済むので、オーディオスレッドでも安全です
    """
  }
}

#Preview {
  SlidePreview {
    ResamplingSlide()
  }
}
