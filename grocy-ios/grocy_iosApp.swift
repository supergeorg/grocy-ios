//
//  grocy_iosApp.swift
//  grocy-ios
//
//  Created by Georg Meissner on 11.10.20.
//

import SwiftUI

@main
struct grocy_iosApp: App {
//    @EnvironmentObject var grocyVM: GrocyViewModel
    
    var body: some Scene {
        WindowGroup {
            ContentView()//.environmentObject($grocyVM)
        }
    }
}
