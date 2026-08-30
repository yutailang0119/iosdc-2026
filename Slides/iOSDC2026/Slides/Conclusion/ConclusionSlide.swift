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
      Item("1行の式と標準フレームワークだけで音楽が鳴る")
      Item("Swift実装のポイント") {
        Item("AVAudioSourceNode で t を進めながらサンプルを返す")
        Item("式の評価は JavaScriptCore、オーディオスレッドでは自前")
        Item("Mutex.withLockIfAvailable で待たずに差し替える")
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
      }
    }
    .background(.background)
  }

  var script: String {
    """
    1行の式と標準フレームワークだけで、音楽が鳴りました
    ポイントは3つ
    AVAudioSourceNodeでサンプルを返すこと、式を評価すること、待たずに差し替えること
    コードはこのリポジトリにあります
    ぜひ手元で式を変えて遊んでみてください
    """
  }
}

#Preview {
  SlidePreview {
    ConclusionSlide()
  }
}
