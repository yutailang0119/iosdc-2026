import SwiftUI

struct TitleSlide: View {
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
