//
//  NavigationHeaverView.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

import SwiftUI

struct NavigationHeaderView: View {
    
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .BodyEmphasized() //폰트 모디파이어 사용.
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
            
            Divider()
        }
        .background(Color.white)
    }
}
