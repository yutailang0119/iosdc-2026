//
//  AboutTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/17.
//

import SlideKit
import SwiftUI

@Slide
struct AboutTitleSlide: View {
  var body: some View {
    TitleLayout(text: "What is Bytebeat")
      .background(.background)
  }

  var script: String {
    """
    今日はBytebeatについて話しに来ました
    """
  }
}

#Preview {
  SlidePreview {
    AboutTitleSlide()
  }
}
