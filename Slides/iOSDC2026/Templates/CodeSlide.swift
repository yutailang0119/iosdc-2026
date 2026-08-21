import SlideKit
import SwiftUI

struct CodeSlide: View {
  var code: String

  var body: some View {
    CenteringSlide {
      Code(code, syntaxHighlighter: .presentation(fontSize: 36))
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity,
          alignment: .topLeading
        )
        .padding()
        .background(.white)
        .padding()
    }
  }
}
