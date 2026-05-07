//
//  CatInfoInputModelView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/24/26.
//

//
//  CatInfoInputViewModel.swift
//  sugarcat
//고양이 정보 입력 모델뷰 

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
    

    // MARK: - 제출
    func submit() async -> Bool {
        isLoading = true
        
        // 공용 포메터(DateStringFormatter)를 사용하여 날짜를 문자열로 변환
        let birthStr = isBirthDateUnknown ? "" : DateStringFormatter.dateString(from: birthDate)
        let diagnosedStr = isDiagnosedDateUnknown ? "" : DateStringFormatter.dateString(from: diagnosedDate)
        //경고때문에 작성, api 호출 후 지워도 됨 
        print("고양이 이름: \(catName) , 생년월일 : \(birthStr) , 진단일 : \(diagnosedStr)")
        
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
