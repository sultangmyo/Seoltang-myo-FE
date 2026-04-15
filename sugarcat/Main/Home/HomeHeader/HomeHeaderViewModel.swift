//
//  HomeHeaderViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation
import Combine

@MainActor
final class HomeHeaderViewModel: ObservableObject {
    
    // 화면에 보여줄 최종 텍스트
    @Published var titleText: String = "로딩 중..."
    
    // 서비스 의존성
    private let catService: CatServiceProtocol
    
    init(catService: CatServiceProtocol) {
        self.catService = catService
    }
    
    // 데이터 로딩 함수
    func loadHeader() async {
        
        // 1. userId 가져오기
        guard let userId = UserSessionManager.shared.userId else {
            titleText = "유저 정보 없음"
            return
        }
        
        do {
            // 2. 고양이 정보 요청
            let catInfo = try await catService.fetchCatInfo(userId: userId)
            
            // 3. String → Date 변환
            guard let diagnosedDate = DateParser.parse(catInfo.diagnosedDate) else {
                titleText = "날짜 오류"
                return
            }
            
            // 4. D+ 계산
            let dDayText = DDayFormatter.makeDDayText(from: diagnosedDate)
            
            // 5. 최종 문자열 조합
            titleText = "\(catInfo.name) \(dDayText)"
            
        } catch {
            titleText = "불러오기 실패"
        }
    }
}
