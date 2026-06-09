//
//  CatInfoInputViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/24/26.
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
    
    private var store: OnboardingDataStore
    
    init(store: OnboardingDataStore) {
            self.store = store
        }
    
    // MARK: -고양이 정보 임시 저장
    func saveCatInfoToStore() {
            store.name = self.catName
            store.birthDate = self.birthDate
            store.isBirthDateUnknown = self.isBirthDateUnknown
            store.diagnosedDate = self.diagnosedDate
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
