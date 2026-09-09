//
//  ImprintSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/09/07.
//

import BytebeatKit
import SlideKit
import SwiftUI

@Slide
struct ImprintSlide: View {
  enum SlidePhasedState: Int, PhasedState {
    case initial, melody, silent
  }

  @Environment(\.isSoundEnabled) private var isSoundEnabled: Bool
  @Phase var phase: SlidePhasedState
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 32
  )

  var body: some View {
    CenteringLayout {
      VStack(spacing: 8) {
        Text("Enjoy Bytebeat")
        Text("Enjoy iOSDC")
        Text("Thanks!")
      }
      .font(.system(size: 160, weight: .bold, design: .default))
    }
    .overlay(alignment: .bottom) {
      switch phase {
      case .initial:
        EmptyView()
      case .melody, .silent:
        Text(phase.expression)
          .font(.system(size: 24, design: .monospaced))
          .foregroundStyle(.secondary)
          .padding(60)
      }
    }
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
        case .initial, .silent:
          controller.stop()
        case .melody:
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
      最後に1曲、1式だけ
      """
    case .melody:
      """
      音高を並べれば、こんな旋律も表現できます
      """
    case .silent:
      """
      ここまでお聴きいただき、ありがとうございました
      """
    }
  }

  var shouldHideIndex: Bool {
    true
  }
}

private extension ImprintSlide.SlidePhasedState {
  var expression: String {
    "(t*[601,900,1201,900,714,1070,1348,1070,601,802,1201,0,674,802,900,0][t>>10&15]>>6&255)*(~t&1023)>>10"
  }
}

#Preview {
  SlidePreview {
    ImprintSlide()
  }
}
