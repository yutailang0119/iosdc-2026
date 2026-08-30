//
//  SourceNodeTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/25.
//

import SlideKit
import SwiftUI

@Slide
struct SourceNodeTitleSlide: View {
  var body: some View {
    TitleLayout(
      text: "t を進めながらサンプルを返す",
      size: 100
    )
    .background(.background)
  }

  var script: String {
    """
    まず、音を鳴らすところです
    """
  }
}

#Preview {
  SlidePreview {
    SourceNodeTitleSlide()
  }
}
