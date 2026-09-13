//
//  ConclusionSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct ConclusionSlide: View {
  var body: some View {
    HeaderSlide("Conclusion") {
      Item("1行の式がそのまま音楽になる") {
        Item("1文字変えれば音が変わる")
        Item("1項足せば音が重なる")
      }
      Item("Swiftなら標準フレームワークだけで書ける") {
        Item("なめらかな音のために、再生に間に合わせることだけが重要")
        Item("JavaScript互換のEvaluatorを自作")
      }
      Item {
        Label {
          Link(
            destination: URL(string: "https://github.com/yutailang0119/iosdc-2026")!
          ) {
            Text("yutailang0119/iosdc-2026")
              .multilineTextAlignment(.leading)
          }
        } icon: {
          Image(.gitHub)
            .resizable()
            .scaledToFit()
            .frame(width: 52, height: 52)
        }
      } child: {
        Item {
          Label {
            Link(
              destination: URL(string: "https://github.com/mtj0928/SlideKit")!
            ) {
              Text("mtj0928/SlideKit")
                .multilineTextAlignment(.leading)
            }
          } icon: {
            Image(.gitHub)
              .resizable()
              .scaledToFit()
              .frame(width: 52, height: 52)
          }
        }
      }
    }
    .background(.background)
  }

  var script: String {
    """
    1行の式が、そのまま音楽になりました
    1文字変えれば音が変わり、1項足せば音が重なります

    Swiftでも、標準フレームワークだけで書けます
    なめらかな音のために、再生に間に合わせることだけが重要です
    ただ、JavaScriptCoreでは足りないので、Evaluatorも自作しています

    コードはリポジトリで公開しています
    Playgroundも用意したので、ぜひ手元で式を変えて遊んでみてください
    """
  }
}

#Preview {
  SlidePreview {
    ConclusionSlide()
  }
}
