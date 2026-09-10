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
    case initial, dora, silent
  }

  @Environment(\.isSoundEnabled) private var isSoundEnabled: Bool
  @Phase var phase: SlidePhasedState
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 1
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
    .background {
      switch phase {
      case .initial:
        EmptyView()
      case .dora, .silent:
        TitleLayout(
          text: phase.expression,
          size: 40
        )
        .foregroundStyle(.tertiary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
          WaveformView(
            controller: controller,
            style: .trace
          )
        }
      }
    }
    .background(.background)
    .onChange(of: phase) { _, newValue in
      guard isSoundEnabled else { return }
      do {
        switch newValue {
        case .initial, .silent:
          controller.stop()
        case .dora:
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
      Enjoy Bytebeat
      """
    case .dora:
      """
      Enjoy iOSDC
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
    "(128+(((((((((((((((((t<24064)?(24064-t):0))>>6)*((((t<24064)?(24064-t):0))>>6))>>8)*((t<64)?t:64))>>6)*(((((((t*466)>>6)^(-((((t*466)>>6)>>7)&1)))&127)-64)*34)+(((((((t*474)+2069)>>6)^(-(((((t*474)+2069)>>6)>>7)&1)))&127)-64)*13)))+(((((((((t<26112)?(26112-t):0))>>6)*((((t<26112)?(26112-t):0))>>6))>>8)*((t<64)?t:64))>>6)*((((((((t*166)+6151)>>6)^(-(((((t*166)+6151)>>6)>>7)&1)))&127)-64)*32)+(((((((t*602)+14371)>>6)^(-(((((t*602)+14371)>>6)>>7)&1)))&127)-64)*9))))+(((((((((t<27136)?(27136-t):0))>>6)*((((t<27136)?(27136-t):0))>>6))>>8)*((t<64)?t:64))>>6)*(((((((t*610)+12302)>>6)^(-(((((t*610)+12302)>>6)>>7)&1)))&127)-64)*21)))+(((((((((((t<27136)?(27136-t):0))>>6)*((((t<27136)?(27136-t):0))>>6))>>8)*((t<64)?t:64))>>6)*(((t>>2)<256)?(t>>2):256))>>8)*(((((((t*2849)+8220)>>6)^(-(((((t*2849)+8220)>>6)>>7)&1)))&127)-64)*9)))+(((((((((t<26112)?(26112-t):0))>>6)*((((t<26112)?(26112-t):0))>>6))>>8)*(((t>>2)<256)?(t>>2):256))>>8)*((((((((((t*166)>>6)^((t*4792)>>6))&255)-128)>>1)*16)+(((((((t*466)>>6)^((t*2849)>>6))&255)-128)>>1)*16))+(((((((((t>>1)*2654435761)^(((t>>1)*2654435761)>>15))&65535)*40503)>>9)&127)-64)*12))+(((((((((t>>1)*2654435761)^(((t>>1)*2654435761)>>15))&65535)*40503)>>9)&127)-64)*14))))+(((((((((t<24064)?(24064-t):0))>>6)*((((t<24064)?(24064-t):0))>>6))>>8)*(((t>>2)<256)?(t>>2):256))>>8)*(((((((t*456)>>6)^((t*3494)>>6))&255)-128)>>1)*16)))+(((((t<320)?(320-t):0))>>2)*(((((((((t>>6)*2654435761)^(((t>>6)*2654435761)>>15))&65535)*40503)>>9)&127)-64)*700)))+(((((t<1920)?(1920-t):0))>>4)*((((((((t*166)>>6)^(-((((t*166)>>6)>>7)&1)))&127)-64)*180)+((((((t*466)>>6)^(-((((t*466)>>6)>>7)&1)))&127)-64)*180))+((((((t*474)>>6)^(-((((t*474)>>6)>>7)&1)))&127)-64)*180))))>>16))"
  }
}

#Preview {
  SlidePreview {
    ImprintSlide()
  }
}
