//
//  ConclusionTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/25.
//

import SlideKit
import SwiftUI

@Slide
struct ConclusionTitleSlide: View {
  var body: some View {
    TitleLayout(text: "Conclusion")
      .background(.background)
  }

  var script: String {
    """
    以上でまとめに入ります
    """
  }
}

#Preview {
  SlidePreview {
    ConclusionTitleSlide()
  }
}
