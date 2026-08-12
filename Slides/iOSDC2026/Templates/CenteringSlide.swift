import SwiftUI

struct CenteringSlide<Content>: View where Content: View {
  var content: () -> Content

  var body: some View {
    content()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
