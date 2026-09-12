#if os(macOS) || os(iOS) || os(visionOS)
import BytebeatKit
import SwiftUI

struct BytebeatPlayground: View {
  @State private var controller = BytebeatController(
    scopeColumnCount: 512,
    samplesPerColumn: 32
  )
  @State private var preset: BytebeatPreset = .pulse
  @State private var expression: String = ""
  @State private var style: WaveformView.Style = .trace
  @State private var errorMessage: String?

  var body: some View {
    VStack {
      HStack {
        Picker("Preset", selection: $preset) {
          ForEach(BytebeatPreset.allCases) { preset in
            Text(preset.title).tag(preset)
          }
        }
        .onChange(of: preset, initial: true) { _, newValue in
          expression = newValue.expression
          if controller.isPlaying {
            play()
          }
        }
        Spacer()
        Picker("Style", selection: $style) {
          Text("Trace")
            .tag(WaveformView.Style.trace)
          Text("Envelope")
            .tag(WaveformView.Style.envelope)
        }
        .pickerStyle(.segmented)
        .fixedSize()
      }
      TextEditor(text: $expression)
        .font(.system(.body, design: .monospaced))
        .autocorrectionDisabled()
        .frame(minHeight: 80, maxHeight: 160)
        .padding()
        .background(.quaternary.opacity(0.3), in: .rect(cornerRadius: 8))
      HStack {
        Button(
          controller.isPlaying ? "Apply" : "Play",
          systemImage: "play.fill"
        ) {
          play()
        }
        .keyboardShortcut(.return, modifiers: .command)
        Button(
          "Stop",
          systemImage: "stop.fill"
        ) {
          controller.stop()
        }
        .disabled(!controller.isPlaying)
        if let errorMessage {
          Text(errorMessage)
            .font(.callout)
            .foregroundStyle(.red)
            .lineLimit(2)
        }
        Spacer()
      }
      WaveformView(controller: controller, style: style)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background, in: .rect(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(.quaternary)
        }
    }
    .padding()
    .onDisappear {
      controller.stop()
    }
  }

  private func play() {
    do {
      try controller.play(expression: expression)
      errorMessage = nil
    } catch {
      errorMessage = String(describing: error)
    }
  }
}

#Preview("Bytebeat Playground") {
  BytebeatPlayground()
    .frame(minWidth: 640, minHeight: 480)
}
#endif
