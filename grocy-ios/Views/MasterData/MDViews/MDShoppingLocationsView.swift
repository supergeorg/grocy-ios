//
//  MDShoppingLocationsView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDShoppingLocationsRowView: View {
    var shoppingLocation: MDShoppingLocation
    
    var body: some View {
        VStack(alignment: .leading){
            Text(shoppingLocation.name)//.font(.title)
            if !shoppingLocation.mdShoppingLocationDescription.isEmpty {
                Text(shoppingLocation.mdShoppingLocationDescription).font(.caption)
            }
        }
    }
}

struct MDShoppingLocationsView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @State private var editMode : EditMode = .inactive
    @State private var showAddShoppingLocation = false
    
        func deleteShoppingLocation(at offsets: IndexSet) {
            for offset in offsets {
                grocyVM.deleteMDObject(object: .shopping_locations, id: grocyVM.mdShoppingLocations[offset].id)
            }
            grocyVM.getMDShoppingLocations()
        }
    
    var body: some View {
        List(){
            Button("__Load Shoppinglocations"){
                grocyVM.getMDShoppingLocations()
            }
            if grocyVM.mdShoppingLocations.isEmpty {
                Text("Keine Geschäfte gefunden. Füge welche hinzu.")
            }
            ForEach(grocyVM.mdShoppingLocations, id:\.id) {shoppingLocation in
                MDShoppingLocationsRowView(shoppingLocation: shoppingLocation)
            }
            .onDelete(perform: deleteShoppingLocation)
//            Button("+Add"){showAddShoppingLocation=true}
//            Button("-Delete"){editMode = .active}
        }
        .onAppear(perform: grocyVM.getMDShoppingLocations)
        .animation(.default)
        .navigationBarTitle("Geschäfte")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack{
                    if !grocyVM.mdShoppingLocations.isEmpty { EditButton() }
                    if !editMode.isEditing {
                        Button(action: {
                            showAddShoppingLocation = true
                        }, label: {Image(systemName: "text.badge.plus")})
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: self.$showAddShoppingLocation, content: { MDAddShoppingLocationView(isShown: self.$showAddShoppingLocation) })
    }
}

struct MDShoppingLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        MDShoppingLocationsView()
    }
}
