//
//  ExchangeTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/25.
//

import SlideKit
import SwiftUI

@Slide
struct ExchangeTitleSlide: View {
  var body: some View {
    TitleLayout(
      text: """
        オーディオスレッドを止めずに、
        式を差し替える
        """,
      size: 100
    )
    .background(.background)
  }

  var script: String {
    """
    最後に、鳴らしたまま式を入れ替えるところです
    """
  }
}

#Preview {
  SlidePreview {
    ExchangeTitleSlide()
  }
}
