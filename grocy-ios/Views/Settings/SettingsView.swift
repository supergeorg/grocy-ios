//
//  SettingsView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 28.10.20.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView() {
            Form() {
                Section(header: Text("Grocy")){
                    NavigationLink(
                        destination: GrocyInfoView(),
                        label: {
                            Text("Infos zu Grocy-Server")
                        })
                    Button("Logout aus Grocy-Server") {
                        isLoggedIn = false
                    }
                }
                Section(header: Text("App")){
                    NavigationLink(
                        destination: AboutView(),
                        label: {
                            Text("Infos zur App")
                        })
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
