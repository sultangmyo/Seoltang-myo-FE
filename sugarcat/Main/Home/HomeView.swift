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
            headerSection
            Spacer()
        }
        .background(Color.white)
        .task {
            await viewModel.loadHeader()
        }
    }
}

private extension HomeView {
    
    var headerSection: some View {
        VStack(spacing: 0) {
            Text(viewModel.titleText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
            
            Divider()
        }
    }
}

#Preview {
    HomeView()
}
