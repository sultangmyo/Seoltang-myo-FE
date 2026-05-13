import SwiftUI

struct OnboardingButtonStyle: ButtonStyle {
    var isValid: Bool
    var isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // 1. 배경 사각형
            RoundedRectangle(cornerRadius: 15)
                .fill(isValid ? Color("primary0") : Color("gray1"))

            // 2. 내부 콘텐츠
            if isLoading {
                ProgressView()
                    .tint(Color("textbg2"))
            } else {
                configuration.label
                    .buttontitle1()
                    .foregroundColor(Color("textbg2"))
            }
        }
        .frame(height: 68)
        .padding(.horizontal, 16) 
        // 버튼 클릭 시 시각적 피드백
        .opacity(configuration.isPressed ? 0.9 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
