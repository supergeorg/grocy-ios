//
//  UserRowView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct UserRowView: View {
    var user: UserDto
    
    var body: some View {
        VStack(alignment: .leading){
            Text(user.displayName ?? "fehler").font(.title)
            Group {
                Text("Username: ")
                    +
                    Text(user.username ?? "fehler")
                    +
                    Text(", ID: ")
                    +
                    Text(user._id ?? "fehler")
            }.font(.caption)
        }
    }
}

//struct UserRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRowView(user: User(id: "5", username: "username", firstName: "firstName", lastName: "lastName", rowCreatedTimestamp: "timestamp", displayName: "dpn"))
//    }
//}
