//
//  Notice.swift
//  sugarcat
//
//  Created by 서세린 on 7/11/26.
//

import Foundation

// MARK: - 현재 활성화된 공지 조회 응답 DTO

struct NoticeActiveResponseDTO: Codable {
    
    // 현재 공지 활성화 여부
    let enabled: Bool
    
    // 공지를 구분하기 위한 고유 식별자
    // ex: "service-end-2026-12"
    let noticeId: String?
    
    // 공지 제목
    let title: String?
    
    // 공지 내용
    let message: String?
}
