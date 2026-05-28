//
//  MyPageTopProfileSectionViewModel.swift
//  sugarcat
//
//  Created by 조수현 on 5/16/26.
//

import Foundation

class MyPageTopProfileSectionViewModel: ObservableObject {
    // 뷰에서 관찰할 상태 변수들
    @Published var catName: String = ""
    @Published var catAgeInfo: String = ""
    @Published var catDiagnosedDate: String = ""
    @Published var rawDiagnosedDate: String = "" //원 본 보관용
    @Published var rawBirthDate: String = ""
    
    @Published var myNickname: String = ""
    @Published var mates: [String] = []
    
    @Published var isLoading: Bool = false
    
    func fetchMypageData() {
        Task {
            // 로딩 시작
            await MainActor.run { self.isLoading = true }
            
            do {
                // 7.1 사용자 정보 및 가족 조회
                let userDTO: UserInfoResponseDTO = try await APIClient.request(
                    path: UserEndpoint.userNicknameCheck.path,
                    method: UserEndpoint.userNicknameCheck.method
                )
                
                // 7.2 고양이 기본정보 조회
                let catDTO: CatInfoResponseDTO = try await APIClient.request(
                    path: CatEndpoint.catInfoCheck.path,
                    method: CatEndpoint.catInfoCheck.method
                )
                
                // 데이터를 정상적으로 받아왔다면 화면에 바인딩
                await MainActor.run {
                    self.processUserData(dto: userDTO)
                    self.processCatData(dto: catDTO)
                    self.isLoading = false
                }
                
            } catch {
                // 에러 발생 시 처리
                print("❌ 마이페이지 데이터 로드 실패: \(error.localizedDescription)")
                await MainActor.run { self.isLoading = false }
            }
        }
    }
    
    /// 2. 사용자 닉네임을 백엔드에 보내서 수정하는 함수
    func updateNickname(newNickname: String, completion: @escaping (Bool) -> Void) {
        Task {
            await MainActor.run { self.isLoading = true }
            
            do {
                let requestDTO = UpdateUserRequestDTO(nickname: newNickname)
                
                try await APIClient.requestWithoutResponse(
                    path: UserEndpoint.userNicknameEdit.path,
                    method: UserEndpoint.userNicknameEdit.method,
                    body: requestDTO
                )
                
                // 200 떨어지면 화면에 뿌림
                await MainActor.run {
                    self.myNickname = newNickname
                    self.isLoading = false
                    completion(true)
                }
            } catch {
                print("❌ 닉네임 수정 실패: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                    completion(false)
                }
            }
        }
    }
    
    // 고양이 데이터 전처리 로직
    private func processCatData(dto: CatInfoResponseDTO) {
        self.catName = dto.name
        self.rawDiagnosedDate = dto.diagnosedDate
        self.rawBirthDate = dto.birthDate ?? ""
        
        // 생일 데이터 분석 및 나이 계산
        if let birthStr = dto.birthDate, !birthStr.isEmpty {
            self.catAgeInfo = calculateAge(from: birthStr)
        } else {
            self.catAgeInfo = "나이 정보 없음"
        }
        
        // 당뇨 진단일(diagnosedDate) 전처리 로직
        let formattedDate = dto.diagnosedDate.replacingOccurrences(of: "-", with: ". ")
        self.catDiagnosedDate = "당뇨 진단일: \(formattedDate)"
    }
    
    // 유저 및 가족 데이터 전처리 로직
    private func processUserData(dto: UserInfoResponseDTO) {
        self.myNickname = dto.nickname
        self.mates = dto.family.map { $0.nickname }
    }
    
    // 나이 계산 함수
    private func calculateAge(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateString.contains("-") ? "yyyy-MM-dd" : "yyyy.MM.dd"
        guard let birthDate = formatter.date(from: dateString) else { return "나이 미정" }
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        
        if let year = components.year, let month = components.month {
            if year > 0 {
                // 1살 이상일 때
                return "\(year)살"
            } else if month > 0 {
                // 개월 수 존재할때
                return "\(month)개월"
            } else {
                // 1달 안 됐을때
                return "1개월 미만"
            }
        }
        return "나이 미정"
    }
}
