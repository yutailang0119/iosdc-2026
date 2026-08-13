//
//  YutailangSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/14.
//

import SlideKit
import SwiftUI

@Slide
struct YutailangSlide: View {
  var body: some View {
    SplitSlide {
      HeaderSlide("yutailang0119") {
        Item("株式会社はてな") {
          Item("京都オフィス")
          Item("アプリケーションエンジニア")
        }
        Item {
          Label {
            Text("try! Swift Tokyo")
          } icon: {
            Image(.riko)
              .resizable()
              .scaledToFit()
              .frame(width: 52, height: 52)
          }
        }
        Item {
          Label {
            Text("Apple Vision Pro座談会")
          } icon: {
            Image(systemName: "vision.pro")
          }
        }
        Item("🐈🐈‍⬛")
      }
    } detail: {
      CenteringSlide {
        Image(.yutailang0119)
          .resizable()
          .scaledToFit()
          .frame(width: 720, height: 720)
      }
    }
    .background(.background)
  }

  var script: String {
    """
    こんにちは、yutailang0119です
    """
  }
}

#Preview {
  SlidePreview {
    YutailangSlide()
  }
}
