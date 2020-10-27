//
//  AddUserView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 12.10.20.
//

import SwiftUI

struct AddUserView: View {
    @ObservedObject private var grocyVM: GrocyViewModel = .shared
    
    @State var username: String = ""
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    
    @State var isValidUsername: Bool = false
    @State var isMatchingPassword: Bool = true
    
    @Binding var isShown: Bool
    
    private func saveUser() {
        grocyVM.postUser(user: User(_id: 0, username: username, firstName: first_name, lastName: last_name, password: password1, rowCreatedTimestamp: Date()))
        grocyVM.getUsers()
    }
    
    private func checkPWParity() {
        if (password1 == password2) && (!password1.isEmpty) {
            isMatchingPassword = true
        } else {
            isMatchingPassword = false
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Button("Abbrechen") {
                    self.isShown = false
                }
                Spacer()
                Button("Nutzer hinzufügen") {
                    saveUser()
                    self.isShown = false
                }.disabled(!(isValidUsername && isMatchingPassword))
            }.padding()
            Form {
                Section(header: Text("Benutzerinfo")){
                    HStack{
                        TextField("Benutzername", text: $username)
                            .disableAutocorrection(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        Image(systemName: isValidUsername ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    if (!isValidUsername && !username.isEmpty) {
                        Text("Benutzername ist schon vergeben.").font(.caption).foregroundColor(Color.red)
                    }
                    if username.isEmpty {
                        Text("Kein Benutzername eingegeben.").font(.caption).foregroundColor(Color.red)
                    }
                    TextField("Vorname", text: $first_name)
                    TextField("Nachname", text: $last_name)
                }
                Section(header: Text("Passwort")){
                    HStack{
                        TextField("Passwort", text: $password1)
                            .disableAutocorrection(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        Image(systemName: isMatchingPassword ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        TextField("Passwort bestätigen", text: $password2)
                            .disableAutocorrection(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        Image(systemName: isMatchingPassword ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    if !isMatchingPassword {
                        Text("Passwörter stimmen nicht überein.").font(.caption).foregroundColor(.red)
                    }
                }
            }.animation(.default)
        }
        .navigationBarTitle("Kontakt hinzufügen")
        .onChange(of: username) { newValue in
            isValidUsername = !(grocyVM.users.filter({$0.username == newValue}).count > 0)
//            if grocyVM.users.filter({$0.username == newValue}).count > 0 {
//                isValidUsername = false
//            } else {
//                isValidUsername = true
//            }
        }
        .onChange(of: password1) { newValue in
            checkPWParity()
        }
        .onChange(of: password2) {  newValue in
            checkPWParity()
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(isShown: Binding.constant(true))
    }
}
