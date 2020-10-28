//
//  ContentView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 11.10.20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("grocyServerURL") var grocyServerURL: String = ""
    @AppStorage("grocyAPIKey") var grocyAPIKey: String = ""
    
    @State var tabSelection: Int = 1
    
    var body: some View {
        if needsAppOnboarding {
            OnboardingView()
        } else if !isLoggedIn {
            LoginView()
        } else {
            TabView(selection: $tabSelection) {
                StockView().tabItem { VStack{
                    Image(systemName: "books.vertical")
                    Text("Stock")
                }}.tag(1)
                ShoppingListView().tabItem { VStack{
                    Image(systemName: "cart")
                    Text("Shopping List")
                } }.tag(2)
                MasterDataView().tabItem { VStack{
                    Image(systemName: "text.book.closed")
                    Text("Master Data")
                } }.tag(3)
                SettingsView().tabItem { VStack{
                    Image(systemName: "gear")
                    Text("Settings")
                }}.tag(4)
                //            CarBodeScannerView().tabItem { VStack{
                //                Image(systemName: "barcode")
                //                Text("Barcode")
                //            }}.tag(5)
            }
            .animation(.default)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tabSelection: 1)
    }
}
