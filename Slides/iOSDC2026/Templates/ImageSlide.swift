import SwiftUI

struct ImageSlide: View {
  var image: Image

  var body: some View {
    image
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 810)
  }
}
