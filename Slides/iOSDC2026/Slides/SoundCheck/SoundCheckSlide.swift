//
//  SoundCheckSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import BytebeatKit
import SlideKit
import SwiftUI

@Slide
struct SoundCheckSlide: View {
  enum SlidePhasedState: Int, PhasedState {
    case initial, pulse

    var foregroundStyle: HierarchicalShapeStyle {
      switch self {
      case .initial: .tertiary
      case .pulse: .primary
      }
    }

    var expression: String {
      switch self {
      case .initial:
        ""
      case .pulse:
        "((t&4095)<800)*(t>>3&1)*(800-(t&4095))>>3"
      }
    }
  }

  @Phase var phase: SlidePhasedState
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 32
  )

  var body: some View {
    TitleLayout(
      text: phase.expression,
      size: 80
    )
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
      do {
        switch newValue {
        case .initial:
          controller.stop()
        case .pulse:
          try controller.play(
            expression: newValue.expression
          )
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
    """
    """
  }
}

#Preview {
  SlidePreview {
    SoundCheckSlide()
  }
}
