//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeHeaderViewModel(
        // 추후에 MockCatService를 CatServiceprotocol로 교체
        catService: MockCatService()
    )
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationHeaderView(title: viewModel.titleText)
            Spacer()
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
