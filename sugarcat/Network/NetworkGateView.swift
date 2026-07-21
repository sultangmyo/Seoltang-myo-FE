//
//  NetworkGateView.swift
//  sugarcat
//

import SwiftUI

//인터넷 없을 때 보이는 화면.
struct NetworkGateView<Content: View>: View {
    let status: NetworkMonitor.Status
    @ViewBuilder let content: () -> Content

    var body: some View {
        switch status {
        case .checking:
            ProgressView("네트워크 연결 확인 중...")

        case .connected:
            content()

        case .disconnected:
            NetworkUnavailableView()
        }
    }
}

private struct NetworkUnavailableView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(.secondary)

            Text("인터넷 연결이 필요해요")
                .font(.title3.weight(.semibold))

            Text("Wi-Fi 또는 모바일 데이터 연결을 확인해 주세요.\n연결되면 자동으로 앱을 시작할게요.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(32)
    }
}
