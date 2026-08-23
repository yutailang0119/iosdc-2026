import SlideKit
import SwiftUI

struct TitleLayout: View {
  private var text: Text
  private var size: CGFloat

  init(text: String, size: CGFloat = 160) {
    self.init(text: Text(text), size: size)
  }

  init(text: Text, size: CGFloat = 160) {
    self.text = text
    self.size = size
  }

  var body: some View {
    text
      .font(.system(size: size, weight: .bold, design: .default))
      .multilineTextAlignment(.center)
  }
}

#Preview("String") {
  TitleLayout(text: "Hello, Swift")
    .frame(
      width: SlideSize.standard16_9.width,
      height: SlideSize.standard16_9.height
    )
    .background(.background)
}

#Preview("Text") {
  TitleLayout(
    text: Text("Hello, \(Text("Swift").foregroundStyle(.tint))")
  )
  .frame(
    width: SlideSize.standard16_9.width,
    height: SlideSize.standard16_9.height
  )
  .background(.background)
}
