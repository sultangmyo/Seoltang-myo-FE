import Foundation
import SwiftUI
import Combine

@MainActor
class InviteViewModel: ObservableObject {
    @Published var inviteCode: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlarmModal: Bool = false

        /// 초대 코드 유효성 검증
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

    
    
    /// 알림 설정 선택 후 후속 작업
    func handleAlarmSetting(isAllowed: Bool, path: Binding<NavigationPath>) {
        // [필요시] 알림 권한 설정 API 호출
        
        // 온보딩 스택을 비우고 메인 페이지로 이동
        path.wrappedValue = NavigationPath()
        path.wrappedValue.append(OnboardingPage.mainHome)
    }
}
