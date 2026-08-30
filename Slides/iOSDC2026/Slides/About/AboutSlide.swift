//
//  AboutSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import SlideKit
import SwiftUI

@Slide
struct AboutSlide: View {
  var body: some View {
    HeaderSlide("What is Bytebeat") {
      Item("1行の式がそのまま音になる") {
        Item("時刻 t を0から増やしながら、1行の式を評価")
        Item("1回の評価が、そのまま1サンプル")
      }
      Item("8,000Hz と 8bitが前提") {
        Item("シンセも音源ファイルもサンプリングも不要")
      }
      Item("2011年 viznut “one line of code”")
    }
    .background(.background)
  }

  var script: String {
    """
    Bytebeatは、1行の式をそのまま音にする音楽です
    時刻 t を0から1つずつ増やして、式を評価する
    その結果が、そのまま波形の1サンプルになります
    ここでの前提は8,000Hz と 8bitであることだけ
    シンセも音源ファイルもサンプリングもありません
    2011年にviznutが「1行のコードによるアルゴリズム交響曲」として公開したのが始まりです
    """
  }
}

#Preview {
  SlidePreview {
    AboutSlide()
  }
}
