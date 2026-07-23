import Foundation
import SwiftUI
import Combine

@MainActor
class InviteViewModel: ObservableObject {
    @Published var inviteCode: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlarmModal: Bool = false

    /// 1. 초대 코드 유효성 검증
    func verifyInviteCode() async {
        guard !inviteCode.isEmpty else { return }
        isLoading = true
        
        let endpoint = CatEndpoint.catInviteVerification(inviteCode: inviteCode)
        
        do {
            let _: ValidateInviteCodeResponseDTO = try await APIClient.request(
                path: endpoint.path,
                method: endpoint.method
            )
            
            self.showAlarmModal = true
        } catch {
            print("❌ 초대 코드 검증 실패: \(error)")
        }
        isLoading = false
    }

    /// 2. 온보딩 완료 처리 및 알림 설정 전송
    func finalizeOnboarding(isAllowed: Bool) async -> Bool {
        isLoading = true

        do {
            let _: MessageResponseDTO = try await APIClient.requestWithBody(
                path: AuthEndpoint.onBoardingCompleted.path,
                method: .post,
                body: ["onboardingCompleted": true]
            )

            print("✅ 온보딩 완료 전송 성공")
        } catch {
            print("❌ 온보딩 완료 전송 실패: \(error)")
            isLoading = false
            return false
        }

        do {
            let notificationBody = UpdateAllNotificationRequest(notificationEnabled: isAllowed)
            let _: MessageResponseDTO = try await APIClient.requestWithBody(
                path: UserEndpoint.userNotificationAllEdit.path,
                method: .patch,
                body: notificationBody
            )
            print("✅ 알림 설정 전송 성공")
        } catch {
            print("⚠️ 온보딩은 완료됐지만 알림 설정 전송에 실패했습니다: \(error)")
        }

        isLoading = false
        return true
    }
}
