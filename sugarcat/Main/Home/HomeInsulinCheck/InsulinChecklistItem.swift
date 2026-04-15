//
//  HomeInsulinModel.swift
//  sugarcat
//
//  Created by 서세린 on 4/13/26.
//

import Foundation

struct InsulinChecklistItem: Identifiable {
    
    var id: Int { sequence }   // sequence를 id로 사용
    
    let sequence: Int
    let title: String
    let isInjected: Bool
    let injectedByNickname: String?
    
    var descriptionText: String {
        if isInjected, let injectedByNickname {
            return "\(injectedByNickname)님이 인슐린을 투여했어요."
        } else {
            return "인슐린을 투여하지 않았어요."
        }
    }
}
