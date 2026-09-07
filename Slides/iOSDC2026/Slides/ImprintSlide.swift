//
//  ImprintSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2025/09/07.
//

import BytebeatKit
import SlideKit
import SwiftUI

@Slide
struct ImprintSlide: View {
  var body: some View {
    CenteringLayout {
      VStack(spacing: 8) {
        Text("Enjoy Bytebeat")
        Text("Enjoy iOSDC")
        Text("Thanks!")
      }
      .font(.system(size: 160, weight: .bold, design: .default))
    }
    .background(.background)
  }

  var script: String {
    """
    ありがとうございました
    """
  }

  var shouldHideIndex: Bool {
    true
  }
}

#Preview {
  SlidePreview {
    ImprintSlide()
  }
}
