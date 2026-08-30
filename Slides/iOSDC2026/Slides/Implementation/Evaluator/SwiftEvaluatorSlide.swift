//
//  SwiftEvaluatorSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct SwiftEvaluatorSlide: View {
  var body: some View {
    HeaderSlide("SwiftEvaluator") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    """
    indirect enum Expression {
      case number(Double)
      case time
      case binary(BinaryOperator, Expression, Expression)
      ...
    }

    enum BinaryOperator {
      func apply(_ a: Double, _ b: Double) -> Double {
        switch self {
        case .multiply: a * b
        case .bitwiseAnd: Double(a.jsInt32 & b.jsInt32)
        case .shiftRight: Double(a.jsInt32 >> (b.jsUInt32 & 31))
        ...
        }
      }
    }
    """
  }

  var script: String {
    """
    ただ、JSValueの呼び出しは、オーディオスレッドから使えません
    メモリ確保やロックが起きるので、締切に間に合いません
    ということで、式のパーサとインタプリタを自分で作りました
    厄介なのはJavaScriptの数値です
    かけ算はDoubleのまま、ビット演算だけ32ビット整数を経由します
    シフト量も下位5ビットにマスクされます
    ここを再現しないと音が変わります
    JavaScriptCore版と出力が一致することは確認しながら作っています
    """
  }
}

#Preview {
  SlidePreview {
    SwiftEvaluatorSlide()
  }
}
