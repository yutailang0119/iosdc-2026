import SlideKit
import SwiftUI

struct CodeSlide: View {
  var code: String

  var body: some View {
    CenteringSlide {
      Color.white
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(52)
        .overlay {
          Code(code, syntaxHighlighter: .presentation(fontSize: 36))
        }
    }
  }
}
