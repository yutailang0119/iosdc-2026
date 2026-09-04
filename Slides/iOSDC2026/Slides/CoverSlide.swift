//
//  CoverSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/14.
//

import SlideKit
import SwiftUI

@Slide
struct CoverSlide: View {
  var body: some View {
    CenteringLayout {
      VStack(spacing: 100) {
        VStack {
          Text(
            """
            `t*(42&t>>10)`だけで音楽が鳴る、
            Swiftで実装するBytebeat
            """
          )
          .font(.system(size: 120, weight: .bold, design: .default))
          .multilineTextAlignment(.center)
        }
        VStack(spacing: 40) {
          Text("Yutaro Muta @yutailang0119")
            .font(.system(size: 80, weight: .bold, design: .default))
            .foregroundStyle(.tint)
          VStack(spacing: 20) {
            Text("2026/09/13 15:30〜 iOSDC Japan 2026")
              .font(.system(size: 60, weight: .medium, design: .default))
              .foregroundStyle(.secondary)
            Link(
              destination: URL(
                string: "https://fortee.jp/iosdc-japan-2026/proposal/60b58d12-61d2-4b0b-a06b-3397f4452b1d"
              )!
            ) {
              Text("https://fortee.jp/iosdc-japan-2026/proposal/60b58d12-61d2-4b0b-a06b-3397f4452b1d")
                .multilineTextAlignment(.center)
            }
            .font(.system(size: 32, weight: .medium, design: .default))
            .underline()
          }
        }
      }
    }
    .background(.background)
  }

  var shouldHideIndex: Bool {
    true
  }

  var script: String {
    """
    よろしくお願いします
    1行の式と音の話をします
    """
  }
}

#Preview {
  SlidePreview {
    CoverSlide()
  }
}
