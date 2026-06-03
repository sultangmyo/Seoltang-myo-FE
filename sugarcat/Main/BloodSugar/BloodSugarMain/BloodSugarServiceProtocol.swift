//
//  BloodSugarServiceProtocol.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import Foundation

protocol BloodSugarServiceProtocol {
    
    // MARK: Fetch Setting
    // 이 값을 기반으로 버튼 개수를 생성함
    func fetchBloodSugarSetting() async throws -> CatCareBloodSugarFetchResponseDTO
    
    // MARK: Fetch Records
    func fetchBloodSugarRecords(date: String) async throws -> BloodSugarFetchResponseDTO
    
    // MARK: Create
    func createBloodSugarRecord(_ request: BloodSugarCreateRequestDTO) async throws -> BloodSugarCreateResponseDTO

    // MARK: Update
    func updateBloodSugarRecord(_ request: BloodSugarUpdateRequestDTO) async throws
    
    // MARK: Delete
    func deleteBloodSugarRecord(sequence: Int, date: String) async throws
}

// MARK: - mock service: 백엔드 연동후 삭제합니다.

final class MockBloodSugarService: BloodSugarServiceProtocol {
        
    // 온보딩에서 하루 혈당 측정 횟수를 4회로 설정했다고 가정
    private var mockSetting = CatCareBloodSugarFetchResponseDTO(
        count: 4,
        schedules: []
    )
    
    // 날짜별 혈당 기록 저장소
    private static var mockRecordsByDate: [String: [BloodSugarRecordDTO]] = [:]
    
    
    // MARK: - Fetch Setting
    
    func fetchBloodSugarSetting() async throws -> CatCareBloodSugarFetchResponseDTO {
        return mockSetting
    }
    
    
    // MARK: - Fetch Records
    
    func fetchBloodSugarRecords(date: String) async throws -> BloodSugarFetchResponseDTO {
        let records = Self.mockRecordsByDate[date] ?? []
        return BloodSugarFetchResponseDTO(records: records)
    }
    
    
    // MARK: - Create
    
    func createBloodSugarRecord(_ request: BloodSugarCreateRequestDTO) async throws -> BloodSugarCreateResponseDTO {
        
        let status = makeSugarStatus(from: request.sugarValue)
        
        let newRecord = BloodSugarRecordDTO(
            nickname: "희재",
            recordTime: request.recordedTime,
            sequence: request.sequence,
            sugarValue: request.sugarValue,
            sugarStatus: status
        )
        
        var records = Self.mockRecordsByDate[request.recordedDate] ?? []
        
        // 같은 sequence가 이미 있으면 생성 대신 교체
        records.removeAll { $0.sequence == request.sequence }
        records.append(newRecord)
        records.sort { $0.sequence < $1.sequence }
        
        Self.mockRecordsByDate[request.recordedDate] = records
        
        return BloodSugarCreateResponseDTO(
            id: UUID().uuidString,
            sugarStatus: status
        )
    }
    
    
    // MARK: - Update
    
    func updateBloodSugarRecord(_ request: BloodSugarUpdateRequestDTO) async throws {
        
        let status = makeSugarStatus(from: request.sugarValue)
        
        let updatedRecord = BloodSugarRecordDTO(
            nickname: "희재",
            recordTime: request.recordedTime,
            sequence: request.sequence,
            sugarValue: request.sugarValue,
            sugarStatus: status
        )
        
        var records = Self.mockRecordsByDate[request.recordedDate] ?? []
        
        records.removeAll { $0.sequence == request.sequence }
        records.append(updatedRecord)
        records.sort { $0.sequence < $1.sequence }
        
        Self.mockRecordsByDate[request.recordedDate] = records
    }
    
    
    // MARK: - Delete
    
    func deleteBloodSugarRecord(sequence: Int, date: String) async throws {
        
        var records = Self.mockRecordsByDate[date] ?? []
        records.removeAll { $0.sequence == sequence }
        
        Self.mockRecordsByDate[date] = records
    }
    
    
    // MARK: - Private
    
    // Mock에서는 백엔드 대신 상태를 임시 계산
    // 실제 서버 연동 후에는 이 로직은 필요 없음
    private func makeSugarStatus(from value: Int) -> SugarStatus {
        if value < 80 {
            return .low
        } else if value <= 150 {
            return .normal
        } else {
            return .high
        }
    }
}

// MARK: - Real BloodSugar Service
// 실제 서버 API를 호출해서 혈당 데이터를 처리하는 서비스
final class RealBloodSugarService: BloodSugarServiceProtocol {
    
    // MARK: - Fetch Setting
    
    // 혈당 체크 설정 조회
    func fetchBloodSugarSetting() async throws -> CatCareBloodSugarFetchResponseDTO {
        try await APIClient.request(
            path: CatCareEndpoint.bloodsugarRecordsCheck.path,
            method: CatCareEndpoint.bloodsugarRecordsCheck.method
        )
    }
    
    // MARK: - Fetch Records
    
    // 특정 날짜 기준 혈당 기록 조회
    func fetchBloodSugarRecords(
        date: String
    ) async throws -> BloodSugarFetchResponseDTO {
        try await APIClient.request(
            path: BloodSugarEndpoint.fetchBloodSugarRecords(
                date: date
            ).path,
            method: BloodSugarEndpoint.fetchBloodSugarRecords(
                date: date
            ).method
        )
    }
    
    // MARK: - Create
    
    // 혈당 기록 생성
    // POST는 201 응답으로 id, sugarStatus를 반환함
    func createBloodSugarRecord(
        _ request: BloodSugarCreateRequestDTO
    ) async throws -> BloodSugarCreateResponseDTO {
        try await APIClient.requestWithBody(
            path: BloodSugarEndpoint.saveBloodSugarRecord.path,
            method: BloodSugarEndpoint.saveBloodSugarRecord.method,
            body: request
        )
    }
    
    // MARK: - Update
    
    // 혈당 기록 수정
    // PATCH는 204 No Content라 반환값 없음
    func updateBloodSugarRecord(
        _ request: BloodSugarUpdateRequestDTO
    ) async throws {
        try await APIClient.requestWithoutResponse(
            path: BloodSugarEndpoint.updateBloodSugarRecord.path,
            method: BloodSugarEndpoint.updateBloodSugarRecord.method,
            body: request
        )
    }
    
    // MARK: - Delete
    
    // 혈당 기록 삭제
    // DELETE는 query parameter로 sequence/date를 보내고,
    // 204 No Content라 반환값 없음
    func deleteBloodSugarRecord(
        sequence: Int,
        date: String
    ) async throws {
        try await APIClient.requestWithoutResponse(
            path: BloodSugarEndpoint.deleteBloodSugarRecord(
                sequence: sequence,
                date: date
            ).path,
            method: BloodSugarEndpoint.deleteBloodSugarRecord(
                sequence: sequence,
                date: date
            ).method
        )
    }
}
