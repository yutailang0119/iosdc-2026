//
//  ExchangeSlide.swift
//  iOSDC2026
//
//  Created by Yutaro Muta on 2026/08/21.
//

import SlideKit
import SwiftUI

@Slide
struct ExchangeSlide: View {
  var body: some View {
    HeaderSlide("Mutex.withLockIfAvailable") {
      CodeLayout(code: code)
    }
    .background(.background)
  }

  private var code: String {
    """
    private let exchange = Mutex(Exchange())

    @MainActor func setEvaluator(_ evaluator: any BytebeatEvaluator) {
      exchange.withLock {
        $0.pending = Voice(evaluator: evaluator)
        $0.retired = nil
      }
    }

    func refresh() -> Bool {
      exchange.withLockIfAvailable { exchange in
        guard let pending = exchange.pending else { return false }
        exchange.pending = nil
        exchange.retired = voice
        voice = pending
        return true
      } ?? false
    }
    """
  }

  var script: String {
    """
    上がメインスレッド、下がオーディオスレッドです
    式を差し替えるとき、まずpendingに置くだけ
    オーディオ側はwithLockIfAvailableで、取得できたときにだけ取り込みます
    取れなければ次のコールバックに回すので、待って音が途切れることはありません
    古いvoiceをretiredに逃がしているのは、オーディオスレッドで解放しないためです
    先ほど、1文字変えたときの音が途切れなかったのは、この仕組みのおかげです
    """
  }
}

#Preview {
  SlidePreview {
    ExchangeSlide()
  }
}
