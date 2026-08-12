import AVKit
import SwiftUI

struct VideoSlide: View {
  @State private var player: AVPlayer

  init(url: URL) {
    self.player = AVPlayer(url: url)
  }

  var body: some View {
    VideoPlayer(player: player)
      //      .frame(maxHeight: 810)
      .onAppear {
        player.play()
      }
      .onDisappear {
        player.pause()
      }
  }
}
