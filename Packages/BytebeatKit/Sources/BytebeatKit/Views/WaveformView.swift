import SwiftUI

public struct WaveformView: View {
  var controller: BytebeatController
  var style: Style

  public init(
    controller: BytebeatController,
    style: Style
  ) {
    self.controller = controller
    self.style = style
  }

  public var body: some View {
    Canvas { context, size in
      let columns = controller.scope
      let count = columns.count
      guard count > 0 else { return }

      let columnWidth = size.width / CGFloat(count)

      switch style {
      case .envelope:
        var trace = Path()
        for (i, column) in columns.enumerated() {
          let x = CGFloat(i) * columnWidth
          trace.move(to: CGPoint(x: x, y: position(of: column.max, in: size)))
          trace.addLine(to: CGPoint(x: x, y: position(of: column.min, in: size)))
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

      case .trace:
        let seam = (controller.scopeCursor + 1) % count
        var trace = Path()
        var isDrawing = false
        for i in 0..<count {
          let column = columns[i]
          let point = CGPoint(
            x: (CGFloat(i) + 0.5) * columnWidth,
            y: position(of: (column.min + column.max) / 2, in: size)
          )
          if i == seam {
            isDrawing = false
          }
          if isDrawing {
            trace.addLine(to: point)
          } else {
            trace.move(to: point)
            isDrawing = true
          }
        }
        context.stroke(
          trace,
          with: .style(.tint),
          style: StrokeStyle(
            lineWidth: max(2, size.height / 180),
            lineCap: .round,
            lineJoin: .round
          )
        )
      }
    }
  }
}

extension WaveformView {
  public enum Style: Sendable {
    case envelope
    case trace
  }
}

private extension WaveformView {
  func position(of value: Float, in size: CGSize) -> CGFloat {
    size.height * (0.5 - CGFloat(value) * 0.5)
  }
}
