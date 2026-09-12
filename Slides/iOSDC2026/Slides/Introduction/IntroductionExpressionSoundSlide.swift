//
//  IntroductionExpressionSoundSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import BytebeatKit
import SlideKit
import SwiftUI

@Slide
struct IntroductionExpressionSoundSlide: View {
  enum SlidePhasedState: Int, PhasedState {
    case initial, second
  }

  @Environment(\.isSoundEnabled) private var isSoundEnabled: Bool
  @Phase var phase: SlidePhasedState
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 1
  )

  var body: some View {
    TitleLayout(text: phase.expression)
      .foregroundStyle(phase.foregroundStyle)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background {
        WaveformView(
          controller: controller,
          style: .trace
        )
      }
      .background(.background)
      .onChange(of: phase) { _, newValue in
        guard isSoundEnabled else { return }
        do {
          switch newValue {
          case .initial:
            controller.stop()
          case .second:
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
      まずはタイトルの式をお聴きください
      """
    case .second:
      """
      お聴きいただいてる音は、この1行の式そのものです
      シンセも音源ファイルも使っていません
      スライド背景に表示している波形も、この式が作った音を表現しています
      """
    }
  }
}

private extension IntroductionExpressionSoundSlide.SlidePhasedState {
  var expression: String {
    "t*(42&t>>10)"
  }

  var foregroundStyle: HierarchicalShapeStyle {
    switch self {
    case .initial: .tertiary
    case .second: .primary
    }
  }
}

#Preview {
  SlidePreview {
    IntroductionExpressionSoundSlide()
  }
}
