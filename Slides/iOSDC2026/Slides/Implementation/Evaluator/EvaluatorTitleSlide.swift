//
//  EvaluatorTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/25.
//

import SlideKit
import SwiftUI

@Slide
struct EvaluatorTitleSlide: View {
  var body: some View {
    TitleLayout(
      text: "JavaScriptの式を評価する",
      size: 100
    )
    .background(.background)
  }

  var script: String {
    """
    次に、式をどう評価するか
    先ほど1文字変えて音が変わったのは、式が実行時の文字列だからです
    """
  }
}

#Preview {
  SlidePreview {
    EvaluatorTitleSlide()
  }
}
