//
//  ImplementationTitleSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct ImplementationTitleSlide: View {
  var body: some View {
    TitleLayout(
      text: """
        Implement Bytebeat
        in Swift
        """
    )
    .background(.background)
  }

  var script: String {
    """
    ここからはSwiftでの実装を考えます
    """
  }
}

#Preview {
  SlidePreview {
    ImplementationTitleSlide()
  }
}
