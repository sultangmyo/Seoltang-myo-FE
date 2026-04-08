//
//  Font.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//


import SwiftUI

//모디파이어
struct MainTitleBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .largeTitle) private var fontSize: CGFloat = 34

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct SubTitle1BModifier: ViewModifier {
    @ScaledMetric(relativeTo: .title) private var fontSize: CGFloat = 24

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct SubTitle2BModifier: ViewModifier {
    @ScaledMetric(relativeTo: .title2) private var fontSize: CGFloat = 24

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Body1SBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .body) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Body1MBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .body) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Body2RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .subheadline) private var fontSize: CGFloat = 18

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct Caption1SBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption) private var fontSize: CGFloat = 16

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Caption2RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption) private var fontSize: CGFloat = 16

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct Caption3RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption2) private var fontSize: CGFloat = 13

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct GraphBarTitleModifier: ViewModifier {
    @ScaledMetric(relativeTo: .subheadline) private var fontSize: CGFloat = 18

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Buttontitle1Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .headline) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Buttontitle2Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .headline) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct NumberCaption1Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .largeTitle) private var fontSize: CGFloat = 72

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct NumberCaption2Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .title) private var fontSize: CGFloat = 48

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}


//익스텐션 사용
extension View {
    func mainTitleB() -> some View {
        modifier(MainTitleBModifier())
    }

    func subTitle1B() -> some View {
        modifier(SubTitle1BModifier())
    }
}
