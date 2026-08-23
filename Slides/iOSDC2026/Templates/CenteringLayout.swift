import SlideKit
import SwiftUI

struct CenteringLayout<Content>: View where Content: View {
  var content: () -> Content

  var body: some View {
    content()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  CenteringLayout {
    Text("CenteringLayout")
      .font(.system(size: 120, weight: .bold))
  }
  .frame(
    width: SlideSize.standard16_9.width,
    height: SlideSize.standard16_9.height
  )
  .background(.background)
}
