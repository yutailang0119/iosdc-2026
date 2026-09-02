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
    case initial, pulse, baibai

    var foregroundStyle: HierarchicalShapeStyle {
      switch self {
      case .initial: .tertiary
      case .pulse, .baibai: .primary
      }
    }

    var expression: String {
      switch self {
      case .initial:
        ""
      case .pulse:
        "((t&4095)<800)*(t>>3&1)*(800-(t&4095))>>3"
      case .baibai:
        "((t*[0,1011,1135,1274,1350,1515,1701,2023][[112338,112338,6928082,45,262134,187227,7451785,18][t*3>>14&7]>>(t*3>>11&7)*3&7]>>6&255)+(t*([253,239,213,189,338,319,284,189][t*3>>14&7]<<(t*3>>12&1))>>7&127))*(~(t*3)&4095)>>13"
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
        case .pulse, .baibai:
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
