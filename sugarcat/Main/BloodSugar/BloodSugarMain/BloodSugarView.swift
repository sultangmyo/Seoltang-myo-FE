//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct BloodSugarView: View {
    //네비게이션
    @State private var path = NavigationPath()
    
    // 알림 route 감지용 Router
        @StateObject private var pushRouter = PushNotificationRouter.shared
    
    @StateObject private var viewModel = BloodSugarViewModel(
        bloodSugarService: MockBloodSugarService()
    )
    
    var body: some View {
        NavigationStack(path: $path) {
            //네비게이션 헤더
            VStack{
                NavigationHeaderView(title: "혈당 기록")
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("오늘의 혈당을 \n기록해주세요")
                        .mainTitleB()
                        .foregroundColor(.textbg1)
                    
                    datePickerSection
                    
                    recordButtonList
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.white)

            .task {
                await viewModel.loadRecords()
            }
            
            .onReceive(pushRouter.$pendingRoute) { route in
                guard route != nil else { return }
                handlePushRouteIfNeeded()
            }
            
            .navigationDestination(for: BloodSugarRecordItem.self) { item in
                BloodSugarInputView(
                    item: item,
                    selectedDate: viewModel.selectedDate,
                    viewModel: viewModel
                )
            }
        }
    }
}

private extension BloodSugarView {
    
    // 알림 route가 혈당 입력이면 해당 sequence의 item을 찾아 입력뷰로 이동하는 함수
    func handlePushRouteIfNeeded() {
        guard case let .bloodSugarInput(_, sequence) = pushRouter.pendingRoute else {
            return
        }

        guard let sequence else {
            return
        }

        guard let item = viewModel.items.first(where: { $0.sequence == sequence }) else {
            return
        }

        path.append(item)
        pushRouter.clear()
    }
    
    var datePickerSection: some View {
        DatePicker(
            "날짜 선택",
            selection: Binding(
                get: { viewModel.selectedDate },
                set: { newDate in
                    Task {
                        await viewModel.changeDate(newDate)
                    }
                }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.compact)
        .labelsHidden()
        .padding(.bottom, 29)
    }
    
    var recordButtonList: some View {
        VStack {
            ForEach(viewModel.items) { item in
                Button {
                    path.append(item)
                } label: {
                    BloodSugarRecordButtonView(item: item)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    BloodSugarView()
}
