//
//  Insulin.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - CREATE (POST 요청)
struct InsulinCreateRequestDTO: Codable {
    let isInjected: Bool     // 투여 여부
    let sequence: Int        // 투여 기록 순서
    let recordDate: String   // 기록 일자 (ex: 2026-04-08)
}

struct InsulinCreateResponseDTO: Codable {
    let message: String // "인슐린 투여 기록이 저장되었습니다."
}

// MARK: - FETCH (GET 요청)
struct InsulinFetchResponseDTO: Codable {
    let records: [InsulinRecordDTO] // 인슐린 투여 기록 배열
}

struct InsulinRecordDTO: Codable {
    let sequence: Int        // 투여 순서
    let isInjected: Bool     // 투여 여부
    let nickName: String     // 투여한 집사 닉네임
}
