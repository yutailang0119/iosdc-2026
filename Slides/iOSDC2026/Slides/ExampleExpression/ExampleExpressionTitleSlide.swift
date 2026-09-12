//
//  ExampleExpressionTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import SlideKit
import SwiftUI

@Slide
struct ExampleExpressionTitleSlide: View {
  var body: some View {
    TitleLayout(text: "t*(42&t>>10)")
      .background(.background)
  }

  var script: String {
    """
    タイトルの式はBytebeatの有名な例でした
    分解していきましょう
    """
  }
}

#Preview {
  SlidePreview {
    ExampleExpressionTitleSlide()
  }
}
