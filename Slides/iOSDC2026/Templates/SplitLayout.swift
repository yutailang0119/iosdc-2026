import SlideKit
import SwiftUI

struct SplitLayout<Content, Detail>: View where Content: View, Detail: View {
  var content: () -> Content
  var detail: () -> Detail

  var body: some View {
    HStack {
      content()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      detail()
        .background(.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

#Preview {
  SplitLayout {
    Text("Content")
      .font(.system(size: 90, weight: .bold))
  } detail: {
    Text("Detail")
      .font(.system(size: 90, weight: .bold))
  }
  .frame(
    width: SlideSize.standard16_9.width,
    height: SlideSize.standard16_9.height
  )
  .background(.background)
}
