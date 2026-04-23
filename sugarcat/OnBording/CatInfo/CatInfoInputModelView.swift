//
//  CatInfoInputModelView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/24/26.
//

//
//  CatInfoInputViewModel.swift
//  sugarcat
//

import Foundation
import Combine

@MainActor
class CatInfoInputViewModel: ObservableObject {
    // 입력값
    @Published var catName: String = ""
    
    @Published var birthDate: Date = Date()
    @Published var diagnosedDate: Date = Date()
    
    // 체크박스
    @Published var isBirthDateUnknown: Bool = false
    @Published var isDiagnosedDateUnknown: Bool = false

    // 상태
    @Published var isLoading: Bool = false
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }

    // MARK: - 제출
    func submit() async -> Bool {
        isLoading = true
        // API 호출 추가 예정
        isLoading = false
        return true
    }
    // MARK: - 유효성 검사
    var isValid: Bool {
        // 이름 필수 입력
        let nameValid = !catName.trimmingCharacters(in: .whitespaces).isEmpty
        
        //진단 날짜가 생일보다 이전일 수는 없음
        if !isBirthDateUnknown && !isDiagnosedDateUnknown {
            return nameValid && (diagnosedDate >= birthDate)
        }
        
        return nameValid
    }
}
