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
    @StateObject var grocyVM: GrocyViewModel = .shared
    
    @Environment(\.openURL) var openURL
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("grocyServerURL") var grocyServerURL: String = ""
    @AppStorage("grocyAPIKey") var grocyAPIKey: String = ""
    
    @State var isCorrectGrocyURL: Bool = false
    @State var isCorrectAPIKey: Bool = false
    
    private func checkGrocyURL() {
        if grocyServerURL.isEmpty { isCorrectGrocyURL = false } else {
            isCorrectGrocyURL = true
        }
    }
    
    private func checkAPIKey() {
        if grocyAPIKey.isEmpty { isCorrectAPIKey = false } else { isCorrectAPIKey = true }
    }
    
    private func checkLogin() {
        grocyVM.checkLoginInfo(baseURL: grocyServerURL, apiKey: grocyAPIKey)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 100, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            MyTextField(textToEdit: $grocyServerURL, description: "Grocy Server URL", isCorrect: $isCorrectGrocyURL, leadingIcon: "network")
                .onChange(of: grocyServerURL, perform: { value in
                    checkGrocyURL()
                })
            MyTextField(textToEdit: $grocyAPIKey, description: "Valid API Key", isCorrect: $isCorrectAPIKey, leadingIcon: "key")
                .onChange(of: grocyAPIKey, perform: { value in
                    checkAPIKey()
                })
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    Button(action: {
                        openURL(URL(string: "\(grocyServerURL)/manageapikeys")!)
                    }, label: {
                        Text("Create Key")
                            .frame(width: geometry.size.width / 2.1, height: 32, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .border(Color.accentColor, width: 2)
                            .foregroundColor(Color.accentColor)
                            .cornerRadius(4)
                    })
                    Button(action: {
                        checkLogin()
                    }, label: {
                        Text("Login")
                            .frame(width: geometry.size.width / 2.1, height: 32, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .border(Color.accentColor, width: 2)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    })
                }
            }
            Spacer()
        }
        .padding(.top, 200)
        .padding(.bottom, 200)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .animation(.default)
        .onAppear(perform: {
            checkGrocyURL()
            checkAPIKey()
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
