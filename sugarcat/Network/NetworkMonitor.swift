//
//  NetworkMonitor.swift
//  sugarcat
//

import Foundation
import Combine
import Network

// 앱의 현재 인터넷 연결 상태를 계속 감시해서, SwiftUI 화면이 그 상태에 맞게 반응할 수 있도록 해주는 객체
@MainActor
final class NetworkMonitor: ObservableObject {
    enum Status {
        case checking
        case connected
        case disconnected
    }

    @Published private(set) var status: Status = .checking

    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.sugarcat.network-monitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let nextStatus: Status = path.status == .satisfied ? .connected : .disconnected

            Task { @MainActor [self, nextStatus] in
                self.status = nextStatus
            }
        }
        monitor.start(queue: monitorQueue)
    }

    deinit {
        monitor.cancel()
    }
}
