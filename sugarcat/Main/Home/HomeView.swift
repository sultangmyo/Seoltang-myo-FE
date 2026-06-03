//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeHeaderViewModel(
        // 추후에 교체
        homeHeaderService: MockHomeHeaderprotocol()
    )
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing:0) {
                // 네비게이션
                NavigationHeaderView(title: viewModel.titleText)
                Divider()
            }
            ScrollView{
                //그래프
                GraphTabView(
                    bloodSugarService: MockBloodSugarService()
                )
                
                //커스텀 divider 적용
                CustomDividerView()
                    .padding(.top, 35)
                    .padding(.bottom, 16)
                
                //인슐린 투여기록
                InsulinChecklistSectionView(insulinService: MockInsulinService())
                Spacer()
            }
        }
        .background(Color.white)
        .task {
            await viewModel.loadHeader()
        }
    }
}

#Preview {
    HomeView()
}
