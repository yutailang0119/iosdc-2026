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
      Item("式は実行時の文字列") {
        Item("JavaScriptの式を評価する") {
          Item("JavaScriptCore → JavaScriptCoreEvaluator")
          Item("Swift製の互換評価器 → SwiftEvaluator")
        }
        Item("オーディオスレッドを止めずに、式を差し替える") {
          Item("Mutex.withLockIfAvailable")
        }
      }
    }
    .background(.background)
  }

  var script: String {
    """
    実装のポイントは2つ
    まず「t の関数」という性質

    もう一点は、「式はコンパイル済みのコードではなく、実行時の文字列」ということです
    再生中に文字を変えて音が変わるのは、この性質によるものです

    サンプルを返す処理は、オーディオスレッドで動きます
    再生は待ってくれないので、間に合わなければ音が途切れます
    """
  }
}

#Preview {
  SlidePreview {
    ImplementationSlide()
  }
}
