//
//  JavaScriptCoreSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct JavaScriptCoreSlide: View {
  var body: some View {
    HeaderSlide("JavaScriptCoreEvaluator") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    #"""
    let context = JSContext()!
    context.evaluateScript(
      "var bytebeat = function(t) { return (\(expression)); }"
    )
    let function = context.objectForKeyedSubscript("bytebeat")!

    func evaluate(t: UInt32) -> UInt8 {
      let result = function.call(withArguments: [Double(t)])!
      return UInt8(truncatingIfNeeded: result.toInt32())
    }
    """#
  }

  var script: String {
    """
    Bytebeatの式は、実はJavaScriptです
    なのでJavaScriptCoreに渡せば、これだけで動きます
    式を関数の中に埋め込んで、tを渡して呼ぶ
    返ってきた値を下位8ビットに切り詰めるだけです
    エラー処理は省いていますが、実質7行です
    """
  }
}

#Preview {
  SlidePreview {
    JavaScriptCoreSlide()
  }
}
