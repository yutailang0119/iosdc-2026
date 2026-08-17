import SwiftUI

public struct WaveformView: View {
  var controller: BytebeatController

  public init(controller: BytebeatController) {
    self.controller = controller
  }

  public var body: some View {
    Canvas { context, size in
      let columns = controller.scope
      let count = columns.count
      guard count > 0 else { return }

      let columnWidth = size.width / CGFloat(count)

      var trace = Path()
      for (i, column) in columns.enumerated() {
        let x = CGFloat(i) * columnWidth
        let top = size.height * (0.5 - CGFloat(column.max) * 0.5)
        let bottom = size.height * (0.5 - CGFloat(column.min) * 0.5)
        trace.move(to: CGPoint(x: x, y: top))
        trace.addLine(to: CGPoint(x: x, y: bottom))
      }
      context.stroke(
        trace,
        with: .style(.tint),
        lineWidth: max(1, columnWidth)
      )

      let cursorX = (CGFloat(controller.scopeCursor) + 0.5) * columnWidth
      var cursor = Path()
      cursor.move(to: CGPoint(x: cursorX, y: 0))
      cursor.addLine(to: CGPoint(x: cursorX, y: size.height))
      context.stroke(
        cursor,
        with: .style(.tint.opacity(0.4)),
        lineWidth: 1
      )
    }
  }
}
