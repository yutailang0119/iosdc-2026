import SwiftUI

struct TitleSlide: View {
  var text: String
  var size: CGFloat = 160

  var body: some View {
    Text(text)
      .font(.system(size: size, weight: .bold, design: .default))
      .multilineTextAlignment(.center)
  }
}
