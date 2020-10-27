//
//  UserManagementView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 12.10.20.
//

import SwiftUI

struct UserManagementView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    @State private var editMode : EditMode = .inactive
    @State private var showAddUser = false
    
    func deleteUser(at offsets: IndexSet) {
        for offset in offsets {
            print("deleting user with id ")
            print(grocyVM.users[offset]._id ?? "Fehler")
            if grocyVM.users[offset]._id != nil {
                grocyVM.deleteUser(id: grocyVM.users[offset]._id!)
            }
        }
        grocyVM.getUsers()
    }
    
    var body: some View {
        NavigationView(){
            List{
                Button("Update users"){grocyVM.getUsers()}
                if grocyVM.users.isEmpty {
                    Text("Keine Nutzer gefunden.").padding()
                }
                ForEach(grocyVM.users, id:\._id) {user in
                    UserRowView(user: user)
                }
                .onDelete(perform: deleteUser)
            }
            .animation(.default)
            .navigationBarTitle("Nutzer")
            .onAppear(perform: {
                grocyVM.getUsers()
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack{
                        if !grocyVM.users.isEmpty {EditButton()}
                        if !editMode.isEditing {
                            Button(action: {showAddUser = true
                            }, label: {Image(systemName: "text.badge.plus")})
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .sheet(isPresented: self.$showAddUser, content: {AddUserView(isShown: self.$showAddUser)})
    }
}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        UserManagementView()
    }
}
