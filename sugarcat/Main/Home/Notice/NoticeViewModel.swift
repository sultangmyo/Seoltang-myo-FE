//
//  NoticeViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 7/11/26.
//

import Foundation
import Combine

@MainActor
final class NoticeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // Alert 표시 여부
    @Published var showNoticeAlert: Bool = false
    
    // Alert 제목
    @Published var noticeTitle: String = ""
    
    // Alert 내용
    @Published var noticeMessage: String = ""
    
    
    // MARK: - Dependencies
    
    private let noticeService: NoticeServiceProtocol
    
    
    // MARK: - Private Properties
    
    // 현재 표시 중인 공지 ID
    // 확인 버튼을 눌렀을 때 오늘 본 공지로 저장하기 위해 사용
    private var activeNoticeId: String?
    
    // 같은 화면 생명주기에서 중복 조회 방지
    // HomeView의 .task가 여러 번 실행되어도 API를 반복 호출하지 않게 함
    private var hasCheckedNotice = false
    
    
    // MARK: - Init
    
    init(noticeService: NoticeServiceProtocol) {
        self.noticeService = noticeService
    }
    
    
    // MARK: - Public Methods
    
    // 활성화된 공지가 있는지 확인
    //
    // 정책:
    // - enabled == false면 표시하지 않음
    // - enabled == true면 noticeId 기준으로 오늘 표시했는지 확인
    // - 오늘 처음 보는 공지면 Alert 표시
    // - 같은 날에는 다시 표시하지 않음
    // - 다음 날에는 다시 표시
    func checkActiveNoticeIfNeeded() async {
        guard !hasCheckedNotice else {
            return
        }
        
        hasCheckedNotice = true
        
        do {
            let notice = try await noticeService.fetchActiveNotice()
            
            // 공지가 비활성화 상태면 종료
            guard notice.enabled else {
                return
            }
            
            // title과 message가 모두 없으면 사용자에게 보여줄 내용이 없으므로 종료
            guard notice.title != nil || notice.message != nil else {
                return
            }
            
            let noticeId = resolvedNoticeId(from: notice)
            
            // 오늘 이미 보여준 공지면 Alert 표시하지 않음
            guard shouldShowToday(noticeId: noticeId) else {
                return
            }
            
            activeNoticeId = noticeId
            noticeTitle = notice.title ?? "공지사항"
            noticeMessage = notice.message ?? ""
            showNoticeAlert = true
            
        } catch {
            // 공지 조회 실패는 앱 사용을 막을 정도의 치명적 문제는 아니므로
            // Alert 없이 콘솔에만 출력
            print("공지사항 조회 실패:", error)
        }
    }
    
    // Alert 확인 버튼을 눌렀을 때 호출
    //
    // 확인을 누르면 "영원히 숨김"이 아니라
    // "오늘은 다시 보지 않음"으로 저장함
    func confirmNoticeAlert() {
        guard let activeNoticeId else {
            showNoticeAlert = false
            return
        }
        
        let today = todayString()
        
        UserDefaults.standard.set(
            today,
            forKey: userDefaultsKey(for: activeNoticeId)
        )
        
        showNoticeAlert = false
    }
    
    
    // MARK: - Private Helpers
    
    // 오늘 이 공지를 보여줘야 하는지 판단
    private func shouldShowToday(noticeId: String) -> Bool {
        let key = userDefaultsKey(for: noticeId)
        let lastShownDate = UserDefaults.standard.string(forKey: key)
        let today = todayString()
        
        return lastShownDate != today
    }
    
    // noticeId가 있으면 noticeId 사용
    // 혹시 noticeId가 null이면 title + message로 임시 ID 생성
    private func resolvedNoticeId(
        from notice: NoticeActiveResponseDTO
    ) -> String {
        if let noticeId = notice.noticeId,
           !noticeId.isEmpty {
            return noticeId
        }
        
        return "\(notice.title ?? "")_\(notice.message ?? "")"
    }
    
    // 공지별 마지막 표시 날짜 저장 key
    private func userDefaultsKey(for noticeId: String) -> String {
        "lastShownNoticeDate_\(noticeId)"
    }
    
    // 오늘 날짜 문자열
    // ex: "2026-07-11"
    private func todayString() -> String {
        DateStringFormatter.dateString(from: Date())
    }
}
