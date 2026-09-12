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
    let sampleRate = engine.outputNode.outputFormat(forBus: 0)
      .sampleRate

    let ratio = 8000.0 / sampleRate
    let step = UInt64(ratio * Double(UInt64(1) << 32))
    var accumulator: UInt64 = 0
    var held: Float = 0

    func evaluate() -> Float {
      let previous = UInt32(accumulator >> 32)
      accumulator &+= step
      let t = UInt32(accumulator >> 32)
      if t != previous {
        held = mixer.sample(t: t)
      }
      return held
    }
    """
  }

  var script: String {
    """
    Bytebeatは8,000Hzですが、出力レートはデバイスによって変わるので、outputFormatから受け取ります
    出力の方が高いので、tを1つずつ進めると早送りになって、音程も上がります
    そこで比率を32.32の固定小数点でstepとして持って、accumulatorに足していきます
    上位32ビットを取り出したものがtなので、数サンプルに1回だけtが進みます
    式を評価するのはtが進んだときだけで、それ以外は前の値を返します
    整数の加算だけなので、丸め誤差が溜まらずtがずれていきません
    """
  }
}

#Preview {
  SlidePreview {
    ResamplingSlide()
  }
}
