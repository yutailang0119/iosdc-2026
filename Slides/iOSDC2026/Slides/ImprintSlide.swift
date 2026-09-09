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
    case initial, megalovania, silent
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
    .overlay(alignment: .topTrailing) {
      Credit(phase: phase)
        .padding(60)
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
        case .megalovania:
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
    case .megalovania:
      """
      かなり決め打ちになりますが、この有名な楽曲も音源ファイルやサンプルを使わずに再現可能です
      この1行が、そのまま旋律になっています
      """
    case .silent:
      """
      MEGALOVANIA、Toby Fox の楽曲でした
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
    "(t*[601,601,1202,0,901,0,0,851,0,803,0,715,0,601,715,803][t>>10&15]>>6&255)*(~t&1023)>>10"
  }
}

private extension ImprintSlide {
  struct Credit: View {
    var phase: SlidePhasedState

    var body: some View {
      switch phase {
      case .initial:
        EmptyView()
      case .megalovania, .silent:
        VStack(alignment: .trailing, spacing: 16) {
          Text(phase.expression)
            .font(.system(size: 24, design: .monospaced))
          VStack(alignment: .trailing) {
            Text("“MEGALOVANIA” composed by Toby Fox / UNDERTALE")
            Text("Administered by Materia Music Publishing")
            Link(
              destination: URL(
                string: "https://undertale.tumblr.com/post/139726155020/changing-policy-on-fan-merch"
              )!
            ) {
              Text("https://undertale.tumblr.com/post/139726155020/changing-policy-on-fan-merch")
            }
            .underline()
          }
          .font(.system(size: 18))
          .foregroundStyle(.secondary)
        }
      }
    }
  }
}

#Preview {
  SlidePreview {
    ImprintSlide()
  }
}
