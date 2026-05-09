//
//  sugarcatApp.swift
//  sugarcat
//
//  Created by 서세린 on 4/6/26.
//

import SwiftUI

@main
struct sugarcatApp: App {
    
    //app delegate 로직 추가
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
        
    var body: some Scene {
        WindowGroup {
            OnBoardingContainerView()
        }
    }
}
