import SlideKit
import SwiftUI

struct CodeLayout: View {
  var code: String

  var body: some View {
    Code(
      code,
      syntaxHighlighter: .presentation(fontSize: 32)
    )
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading
    )
    .padding()
    .background(.white)
    .overlay {
      Rectangle()
        .strokeBorder(.separator, lineWidth: 2)
    }
    .padding()
  }
}

#Preview {
  CodeLayout(
    code: """
      struct Counter {
        private(set) var count = 0

        mutating func increment(by amount: Int = 1) {
          count += amount
        }
      }

      var counter = Counter()
      counter.increment(by: 2)
      print(counter.count)
      """
  )
  .frame(
    width: SlideSize.standard16_9.width,
    height: SlideSize.standard16_9.height
  )
  .background(.background)
}
