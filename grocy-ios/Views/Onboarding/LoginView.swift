//
//  LoginView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 26.10.20.
//

import SwiftUI

struct LoginFieldView: View {
    @Binding var textToEdit: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3){
            Text(description).font(.caption)
            TextField(description, text: $textToEdit)
        }
    }
}

struct LoginView: View {
    //    @State var tempgrocyServerURL: String = ""
    //    @State var tempgrocyAPIKey: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("grocyServerURL") var grocyServerURL: String = ""
    @AppStorage("grocyAPIKey") var grocyAPIKey: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "tag").font(.title)
            Form(){
                LoginFieldView(textToEdit: $grocyServerURL, description: "Server URL")
                LoginFieldView(textToEdit: $grocyAPIKey, description: "Valid API Key")
                HStack(spacing: 20) {
                    Button(action: {print("create key")}, label: {
                        Text("Create Key")
                    })
                    Button(action: {
                        print("login")
                        isLoggedIn = true
                    }, label: {
                        Text("Login")
                    })
                }
                Button(action: {print("create key")}, label: {
                    Text("Use Demo account")
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
