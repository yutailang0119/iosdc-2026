import SlideKit
import SwiftUI

struct ImageLayout: View {
  var image: Image

  var body: some View {
    image
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 810)
  }
}

#Preview {
  ImageLayout(
    image: Image(systemName: "cat")
  )
  .frame(
    width: SlideSize.standard16_9.width,
    height: SlideSize.standard16_9.height
  )
  .background(.background)
}
