//
//  MDLocationsView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDLocationsRowView: View {
    var location: MDLocation
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(location.name)//.font(.title)
                if (location.isFreezer as NSString).boolValue {
                    Image(systemName: "thermometer.snowflake")
                }
            }
            if location.mdLocationDescription != nil {
                if !location.mdLocationDescription!.isEmpty {
                    Text(location.mdLocationDescription!).font(.caption)
                }
            }
        }
    }
}

struct MDLocationsView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @State private var editMode : EditMode = .inactive
    @State private var showAddLocation = false
    
    func deleteLocation(at offsets: IndexSet) {
        for offset in offsets {
            grocyVM.deleteMDObject(object: .locations, id: grocyVM.mdLocations[offset].id)
        }
        grocyVM.getMDLocations()
    }
    
    var body: some View {
        List(){
            Button("Lade Standorte") {
                grocyVM.getMDLocations()
            }
            if grocyVM.mdLocations.isEmpty {
                Text("Keine Standorte gefunden. Füge welche hinzu.")
            }
            ForEach(grocyVM.mdLocations, id:\.id) {location in
                MDLocationsRowView(location: location)
            }
            .onDelete(perform: deleteLocation)
        }
        .animation(.default)
        .navigationBarTitle("Standorte")
        .onAppear(perform: {
            grocyVM.getMDLocations()
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack{
                    if !grocyVM.mdLocations.isEmpty { EditButton() }
                    if !editMode.isEditing {
                        Button(action: {
                            showAddLocation = true
                        }, label: {Image(systemName: "text.badge.plus")})
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: self.$showAddLocation, content: { MDAddLocationView(isShown: self.$showAddLocation) })
    }
}

struct MDLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        MDLocationsView()
    }
}
