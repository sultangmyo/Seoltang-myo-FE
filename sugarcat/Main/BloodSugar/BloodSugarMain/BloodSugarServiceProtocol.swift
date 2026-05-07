//
//  BloodSugarServiceProtocol.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import Foundation

protocol BloodSugarServiceProtocol {
    
    // MARK: - Fetch Setting
    // 이 값을 기반으로 버튼 개수를 생성함
    func fetchBloodSugarSetting() async throws -> CatCareBloodSugarFetchResponseDTO
    
    
    // MARK: - Fetch Records
    // 특정 날짜 기준 혈당 기록 조회

    func fetchBloodSugarRecords(date: String) async throws -> BloodSugarFetchResponseDTO
    
    
    // MARK: - Create
    // 혈당 기록 생성 (처음 입력)
    func createBloodSugarRecord(_ request: BloodSugarCreateRequestDTO) async throws -> MessageResponseDTO
    
    
    // MARK: - Update
    // 혈당 기록 수정 (이미 있는 기록 수정)
    func updateBloodSugarRecord(_ request: BloodSugarUpdateRequestDTO) async throws -> MessageResponseDTO
    
    
    // MARK: - Delete
    // 혈당 기록 삭제
    // sequence + date 기준으로 삭제한다고 가정
    func deleteBloodSugarRecord(sequence: Int, date: String) async throws -> MessageResponseDTO
}



// MARK: - mock service: 백엔드 연동후 삭제합니다.

final class MockBloodSugarService: BloodSugarServiceProtocol {
        
    // 온보딩에서 하루 혈당 측정 횟수를 4회로 설정했다고 가정
    private var mockSetting = CatCareBloodSugarFetchResponseDTO(
        count: 4,
        schedules: []
    )
    
    // 날짜별 혈당 기록 저장소
    private var mockRecordsByDate: [String: [BloodSugarRecordDTO]] = [:]
    
    
    // MARK: - Fetch Setting
    
    func fetchBloodSugarSetting() async throws -> CatCareBloodSugarFetchResponseDTO {
        return mockSetting
    }
    
    
    // MARK: - Fetch Records
    
    func fetchBloodSugarRecords(date: String) async throws -> BloodSugarFetchResponseDTO {
        let records = mockRecordsByDate[date] ?? []
        return BloodSugarFetchResponseDTO(records: records)
    }
    
    
    // MARK: - Create
    
    func createBloodSugarRecord(_ request: BloodSugarCreateRequestDTO) async throws -> MessageResponseDTO {
        
        let status = makeSugarStatus(from: request.sugarValue)
        
        let newRecord = BloodSugarRecordDTO(
            nickName: "희재",
            recordTime: request.recordedTime,
            sequence: request.sequence,
            sugarValue: request.sugarValue,
            sugarStatus: status
        )
        
        var records = mockRecordsByDate[request.recordedDate] ?? []
        
        // 같은 sequence가 이미 있으면 생성 대신 교체
        records.removeAll { $0.sequence == request.sequence }
        records.append(newRecord)
        records.sort { $0.sequence < $1.sequence }
        
        mockRecordsByDate[request.recordedDate] = records
        
        return MessageResponseDTO(message: "혈당 기록이 저장되었습니다.")
    }
    
    
    // MARK: - Update
    
    func updateBloodSugarRecord(_ request: BloodSugarUpdateRequestDTO) async throws -> MessageResponseDTO {
        
        let status = makeSugarStatus(from: request.sugarValue)
        
        let updatedRecord = BloodSugarRecordDTO(
            nickName: "희재",
            recordTime: request.recordedTime,
            sequence: request.sequence,
            sugarValue: request.sugarValue,
            sugarStatus: status
        )
        
        var records = mockRecordsByDate[request.recordedDate] ?? []
        
        records.removeAll { $0.sequence == request.sequence }
        records.append(updatedRecord)
        records.sort { $0.sequence < $1.sequence }
        
        mockRecordsByDate[request.recordedDate] = records
        
        return MessageResponseDTO(message: "혈당 기록이 수정되었습니다.")
    }
    
    
    // MARK: - Delete
    
    func deleteBloodSugarRecord(sequence: Int, date: String) async throws -> MessageResponseDTO {
        
        var records = mockRecordsByDate[date] ?? []
        records.removeAll { $0.sequence == sequence }
        
        mockRecordsByDate[date] = records
        
        return MessageResponseDTO(message: "혈당 기록이 삭제되었습니다.")
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
