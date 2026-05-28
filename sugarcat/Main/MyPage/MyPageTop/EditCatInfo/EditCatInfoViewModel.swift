//
//  EditCatInfoViewModel.swift
//  sugarcat
//
//  Created by 야채샌드 on 5/28/26.
//

import Foundation

class EditCatInfoViewModel: ObservableObject {
    // 뷰와 바인딩할 입력 상태 변수들
    @Published var catName: String = ""
    @Published var birthDate: Date = Date()
    @Published var isBirthDateUnknown: Bool = false
    @Published var diagnosedDate: Date = Date()
    @Published var isDiagnosedDateUnknown: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // 유효성 검사
    var isValid: Bool {
        return !catName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let serverDateParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    /// 기존 고양이 정보 로드 (초기값 세팅용)
    func loadCurrentCatRawData(name: String, rawBirthStr: String, rawDiagnosedStr: String) {
        self.catName = name
        
        // 1. 당뇨 진단일 처리
        if let dDate = serverDateParser.date(from: rawDiagnosedStr) {
            self.diagnosedDate = dDate
            self.isDiagnosedDateUnknown = false
        } else {
            self.isDiagnosedDateUnknown = true
        }
        
        // 2. 생년월일 처리
        if let bDate = serverDateParser.date(from: rawBirthStr) {
            self.birthDate = bDate
            self.isBirthDateUnknown = false
        } else {
            self.isBirthDateUnknown = true
        }
    }
    
    /// 백엔드에 수정된 고양이 정보 Upload (PATCH)
    func updateCatInfo(completion: @escaping (Bool) -> Void) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                
                let birthStr = isBirthDateUnknown ? nil : DateStringFormatter.dateString(from: birthDate)
                let diagnosedStr = isDiagnosedDateUnknown
                ? DateStringFormatter.dateString(from: Date()) // 오늘 날짜를 기본값으로 전송
                : DateStringFormatter.dateString(from: diagnosedDate)
                
                let requestDTO = UpdateCatRequestDTO(
                    name: catName,
                    birthDate: birthStr,
                    diagnosedDate: diagnosedStr
                )
                
                // 고양이 기본정보 수정 호출
                try await APIClient.requestWithoutResponse(
                    path: CatEndpoint.catInfoRewrite.path,
                    method: CatEndpoint.catInfoRewrite.method,
                    body: requestDTO
                )
                
                await MainActor.run {
                    self.isLoading = false
                    completion(true)
                }
                
            } catch {
                print("❌ 고양이 정보 수정 실패: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "정보 수정에 실패했습니다. 다시 시도해주세요."
                    completion(false)
                }
            }
        }
    }
}
