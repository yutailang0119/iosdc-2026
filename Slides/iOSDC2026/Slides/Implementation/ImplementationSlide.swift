//
//  ImplementationSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct ImplementationSlide: View {
  var body: some View {
    HeaderSlide("Implement Bytebeat in Swift") {
      Item("t を進めながらサンプルを返す") {
        Item("AVAudioSourceNode")
      }
      Item("JavaScriptの式を評価する") {
        Item("JavaScriptCore → JavaScriptCoreEvaluator")
        Item("Swift製の互換評価器 → SwiftEvaluator")
      }
      Item("オーディオスレッドを止めずに、式を差し替える") {
        Item("Mutex.withLockIfAvailable")
      }
    }
    .background(.background)
  }

  var script: String {
    """
    Swiftでの実装を見ていきます
    ポイントは3つ
    まず、t を進めながらサンプルを返すこと
    次に、Bytebeatの式はJavaScriptなので、互換の評価器が必要になること
    最後に、式の差し替え時にオーディオスレッドを止めないこと
    順に見ていきます
    """
  }
}

#Preview {
  SlidePreview {
    ImplementationSlide()
  }
}
