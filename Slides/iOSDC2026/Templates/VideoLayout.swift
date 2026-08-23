import AVKit
import SwiftUI

struct VideoLayout: View {
  @State private var player: AVPlayer

  init(url: URL) {
    self.player = AVPlayer(url: url)
  }

  var body: some View {
    VideoPlayer(player: player)
      .onAppear {
        player.play()
      }
      .onDisappear {
        player.pause()
      }
  }
}
