//
//  GrocyInfoView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 12.10.20.
//

import SwiftUI

struct GrocyInfoView: View {
    @ObservedObject private var grocyVM = GrocyViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Grocy").font(.headline)
            Text("Version: ")
            +
                Text(grocyVM.systemInfo?.grocyVersion.version ?? "unknown")
            Text("Release Date: ")
            +
                Text(grocyVM.systemInfo?.grocyVersion.releaseDate ?? "unknown")
            Text("PHP Version: ")
            +
                Text(grocyVM.systemInfo?.phpVersion ?? "unknown")
            Text("SQLite Version: ")
            +
                Text(grocyVM.systemInfo?.sqliteVersion ?? "unknown")
            Text("Letzte Datenbankänderung: ")
            +
                Text(grocyVM.systemDBChangedTime?.changedTime ?? "unknown")
        }.onAppear(perform: {
            grocyVM.getSystemInfo()
            grocyVM.getSystemDBChangedTime()
        })
    }
}

struct GrocyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GrocyInfoView()
    }
}
