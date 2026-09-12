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
      case variable(Int)
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
    ということで、式のパーサとインタプリタを自作しました
    木をたどってDoubleを計算するだけなので、確保もロックもなくオーディオスレッドで動作可能です
    完全な互換は途方もないので、必要な演算を足しながら、JavaScriptCore版と出力が一致することをテストしています
    """
  }
}

#Preview {
  SlidePreview {
    SwiftEvaluatorSlide()
  }
}
