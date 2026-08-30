//
//  SourceNodeSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/20.
//

import SlideKit
import SwiftUI

@Slide
struct SourceNodeSlide: View {
  var body: some View {
    HeaderSlide("AVAudioSourceNode") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    """
    let engine = AVAudioEngine()
    let format = engine.outputNode.outputFormat(forBus: 0)
    let source = AVAudioSourceNode { _, _, frameCount, audioBufferList in
      let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
      for frame in 0..<Int(frameCount) {
        let sample = dsp.evaluate()
        for buffer in buffers {
          buffer.mData?.assumingMemoryBound(to: Float.self)[frame] = sample
        }
      }
      return noErr
    }

    engine.attach(source)
    engine.connect(source, to: engine.mainMixerNode, format: format)
    try engine.start()
    """
  }

  var script: String {
    """
    AVAudioSourceNodeは、音が必要になったタイミングでクロージャを呼びます
    frameCountが要求されたサンプル数なので、その数だけ書いてnoErrを返すだけです
    音源ファイルもオシレータも要りません
    """
  }
}

#Preview {
  SlidePreview {
    SourceNodeSlide()
  }
}
