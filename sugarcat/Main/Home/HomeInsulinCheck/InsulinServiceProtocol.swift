//
//  InsulinServiceProtocol.swift
//  sugarcat
//
//  Created by 서세린 on 4/15/26.
//

import Foundation

// MARK: - 실제 서비스 프로토콜
protocol InsulinServiceProtocol {
    
    // 온보딩에서 저장한 인슐린 설정 정보를 조회하는 함수
    func fetchInsulinSetting() async throws -> CatCareInsulinFetchResponseDTO
    
    // "오늘 날짜 기준" 인슐린 투여 기록을 조회하는 함수
    func fetchTodayInsulinRecords(date: String) async throws -> InsulinFetchResponseDTO
    
    // 사용자가 체크 확인 alert에서 "네"를 눌렀을 때 해당 회차의 인슐린 투여 기록을 서버에 저장하는 함수
    func createInsulinRecord(_ request: InsulinCreateRequestDTO) async throws -> MessageResponseDTO
}

// MARK: - 목업 서비스 프로토콜

// 실제 백엔드 연동 전까지 사용하는 Mock 인슐린 서비스
// InsulinServiceProtocol을 채택해서 ViewModel이 실제 서비스처럼 사용할 수 있게 함
final class MockInsulinService: InsulinServiceProtocol {
    
    // MARK: - Mock Storage
    
    // 온보딩에서 이미 저장되어 있다고 가정하는 인슐린 설정 데이터
    // 예: 하루에 2번 투여하도록 설정된 상태
    private var mockSetting = CatCareInsulinFetchResponseDTO(
        count: 2,
        schedules: [
            CareScheduleDTO(sequence: 1, time: "08:00"),
            CareScheduleDTO(sequence: 2, time: "20:00")
        ]
    )
    
    // 오늘 날짜 기준 인슐린 기록을 저장하는 mock 배열
    // 실제 서버가 없으므로, create 요청이 들어오면 이 배열에 직접 반영함
    private var mockRecords: [InsulinRecordDTO] = []
    
    
    // MARK: - Fetch Setting
    
    // 인슐린 설정 조회
    // 하루에 몇 번 인슐린을 투여하는지, 화면에 체크리스트를 몇 개 그릴지 결정할 때 사용
    func fetchInsulinSetting() async throws -> CatCareInsulinFetchResponseDTO {
        // 실제 네트워크 호출처럼 보이도록 약간의 지연을 줄 수도 있음
        // try await Task.sleep(nanoseconds: 300_000_000)
        
        return mockSetting
    }
    
    
    // MARK: - Fetch Records
    
    // 오늘 날짜의 인슐린 기록 조회
    // 현재는 mockRecords 배열 전체를 그대로 반환
    // 실제 서버에서는 오늘 날짜 기준으로 필터링된 결과가 내려온다고 가정
    func fetchTodayInsulinRecords(date: String) async throws -> InsulinFetchResponseDTO {
        // 실제 네트워크 호출처럼 보이도록 약간의 지연을 줄 수도 있음
        // try await Task.sleep(nanoseconds: 300_000_000)
        
        return InsulinFetchResponseDTO(records: mockRecords)
    }
    
    
    // MARK: - Create Record
    
    // 인슐린 투여 기록 저장
    // 사용자가 alert에서 "네"를 눌렀을 때 호출된다고 가정
    func createInsulinRecord(_ request: InsulinCreateRequestDTO) async throws -> MessageResponseDTO {
        
        // 이미 같은 sequence에 대한 기록이 있으면 중복 저장을 막기 위해 아무 동작도 하지 않음
        // 현재 요구사항상 한 번 체크된 항목은 수정 불가이므로, 기존 기록이 있으면 유지
        if mockRecords.contains(where: { $0.sequence == request.sequence }) {
            return MessageResponseDTO(message: "이미 저장된 인슐린 투여 기록입니다.")
        }
        
        // 실제 협업 앱에서는 서버가 인증된 사용자 정보를 바탕으로 nickname을 저장하겠지만,
        // Mock에서는 임시 닉네임을 직접 넣어줌
        let newRecord = InsulinRecordDTO(
            sequence: request.sequence,
            isInjected: request.isInjected,
            nickName: "희재"
        )
        
        // mock 저장소에 새 기록 추가
        mockRecords.append(newRecord)
        
        // sequence 순서대로 정렬해두면 화면에 안정적으로 보임
        mockRecords.sort { $0.sequence < $1.sequence }
        
        // 실제 서버의 성공 응답을 흉내냄
        return MessageResponseDTO(message: "인슐린 투여 기록이 저장되었습니다.")
    }
}

// MARK: - Real Insulin Service
// 실제 서버 API를 호출해서 인슐린 데이터를 처리하는 서비스
final class RealInsulinService: InsulinServiceProtocol {
    
    // MARK: - Fetch Setting
    
    // 온보딩에서 설정한 인슐린 투여 횟수/시간 조회
    func fetchInsulinSetting() async throws -> CatCareInsulinFetchResponseDTO {
        try await APIClient.request(
            path: CatCareEndpoint.insulinRecordCheck.path,
            method: CatCareEndpoint.insulinRecordCheck.method
        )
    }
    
    // MARK: - Fetch Records
    
    // 선택한 날짜 기준 인슐린 투여 기록 조회
    func fetchTodayInsulinRecords(
        date: String
    ) async throws -> InsulinFetchResponseDTO {
        try await APIClient.request(
            path: InsulinEndpoint.fetchInsulinRecords(date: date).path,
            method: InsulinEndpoint.fetchInsulinRecords(date: date).method
        )
    }
    
    // MARK: - Create Record
    
    // 인슐린 투여 기록 저장
    func createInsulinRecord(
        _ request: InsulinCreateRequestDTO
    ) async throws -> MessageResponseDTO {
        try await APIClient.requestWithBody(
            path: InsulinEndpoint.saveInsulinRecord.path,
            method: InsulinEndpoint.saveInsulinRecord.method,
            body: request
        )
    }
}
