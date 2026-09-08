//
//  ExampleExpressionSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import SlideKit
import SwiftUI

@Slide
struct ExampleExpressionSlide: View {
  enum SlidePhasedState: Int, PhasedState {
    case initial, tempo, scale, pitch

    var baseStyle: HierarchicalShapeStyle {
      self == .initial ? .primary : .tertiary
    }

    var expression: Text {
      let pitchText = fragment("t*", .pitch)
      let scaleText = fragment("42&", .scale)
      let tempoText = fragment("t>>10", .tempo)
      return Text("\(pitchText)(\(scaleText)\(tempoText))")
    }

    func style(for target: Self) -> HierarchicalShapeStyle {
      guard self != .initial else {
        return .primary
      }
      return self == target ? .primary : .tertiary
    }
  }

  @Phase var phase: SlidePhasedState

  var body: some View {
    HeaderSlide {
      phase.expression
        .foregroundStyle(phase.baseStyle)
    } content: {
      Item("t>>10 → テンポ") {
        Item("1,024サンプル ＝ 0.128秒ごとに1ステップ")
      }
      .foregroundStyle(phase.style(for: .tempo))
      Item("42& → 音階") {
        Item("42は二進数で 0b101010") {
          Item("0, 2, 8, 10, 32, 34, 40, 42 の8通り")
          Item("0のときは休符、リズムになる")
        }
      }
      .foregroundStyle(phase.style(for: .scale))
      Item("t* → 音程") {
        Item("256を超えると0に戻る")
        Item("ノコギリ波になる、31.25Hz × 音階の値")
      }
      .foregroundStyle(phase.style(for: .pitch))
    }
    .background(.background)
  }

  var script: String {
    switch phase {
    case .initial:
      """
      3つに分けて読みます
      """
    case .tempo:
      """
      t を10ビット右にシフトした部分がテンポです
      1,024サンプル、0.128秒ごとに1つ進むカウンタになります
      """
    case .scale:
      """
      42とのANDが音階です
      42は二進数で101010なので、かける値は8通りに絞られます
      0になるときは無音、つまり休符で、これがリズムを作っています
      """
    case .pitch:
      """
      最後に、tをかけているところが音程です
      8bitなので256を超えると0に戻る
      その繰り返しがノコギリ波になって、かける値の31.25倍の高さで鳴ります
      """
    }
  }
}

private extension ExampleExpressionSlide.SlidePhasedState {
  func fragment(_ string: String, _ target: Self) -> Text {
    self == target
      ? Text(string).foregroundStyle(.primary)
      : Text(string)
  }
}

#Preview {
  SlidePreview {
    ExampleExpressionSlide()
  }
}
