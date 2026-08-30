//
//  ExampleExpressionSoundSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/20.
//

import BytebeatKit
import SlideKit
import SwiftUI

@Slide
struct ExampleExpressionSoundSlide: View {
  enum SlidePhasedState: Int, PhasedState {
    case initial, second, third, fourth

    private var segments: (head: String, accent: String, tail: String) {
      switch self {
      case .initial, .second: ("t*(42", "&", "t>>10)")
      case .third: ("t*(42", "^", "t>>10)")
      case .fourth: ("t*(42&t>>10)", "+t*(42&t>>11)", "")
      }
    }

    var expression: String {
      segments.head + segments.accent + segments.tail
    }

    var size: CGFloat {
      switch self {
      case .initial, .second, .third: 160
      case .fourth: 136
      }
    }

    var text: Text {
      let (head, accent, tail) = segments
      switch self {
      case .initial:
        return Text("\(head)\(Text(accent))\(tail)")
          .foregroundStyle(.tertiary)
      case .second, .third, .fourth:
        return Text("\(head)\(Text(accent).foregroundStyle(.yellow))\(tail)")
          .foregroundStyle(.primary)
      }
    }
  }

  @Phase var phase: SlidePhasedState
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 1
  )

  var body: some View {
    TitleLayout(
      text: phase.text,
      size: phase.size
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      WaveformView(
        controller: controller,
        style: .trace
      )
    }
    .background(.background)
    .onChange(of: phase) { _, newValue in
      do {
        switch newValue {
        case .initial:
          controller.stop()
        case .second, .third, .fourth:
          try controller.play(expression: newValue.expression)
        }
      } catch {
        print(error)
      }
    }
    .onDisappear {
      controller.stop()
    }
  }

  var script: String {
    switch phase {
    case .initial:
      """
      もう一度聴いてみましょう
      """
    case .second:
      """
      ANDに注目してください
      """
    case .third:
      """
      1文字だけ変えて、ANDをXORにします
      休符が消えて、リズムがなくなりました
      0になる瞬間がなくなったからです
      """
    case .fourth:
      """
      次は項を1つ足します
      同じ旋律が半分の速さで重なりました
      8bitなので足し算は折り返します、混ぜるのではなく算術です
      tの式として評価できれば、音になります
      """
    }
  }
}

#Preview {
  SlidePreview {
    ExampleExpressionSoundSlide()
  }
}
