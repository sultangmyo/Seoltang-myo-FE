//
//  ContentView.swift
//  sugarcat
//
//  Created by 서세린 on 4/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("서브 타이틀")
            .subTitle1B()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
