//
//  MDQuantityUnitsView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDQuantityUnitsRowView: View {
    var quantityUnit: MDQuantityUnit
    
    var body: some View {
        VStack(alignment: .leading){
            Text(quantityUnit.name)//.font(.title)
                +
                Text(" (\(quantityUnit.namePlural))")
            if quantityUnit.mdQuantityUnitDescription != nil {
                if !quantityUnit.mdQuantityUnitDescription!.isEmpty {
                    Text(quantityUnit.mdQuantityUnitDescription!).font(.caption)
                }
            }
        }
    }
}

struct MDQuantityUnitsView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @State private var editMode : EditMode = .inactive
    @State private var showAddQuantityUnit = false
    
    func deleteQuantityUnits(at offsets: IndexSet) {
        for offset in offsets {
            grocyVM.deleteMDObject(object: .quantity_units, id: grocyVM.mdQuantityUnits[offset].id)
        }
        grocyVM.getMDQuantityUnits()
    }
    
    var body: some View {
        List(){
            Button("__Load QuantityUnits"){
                grocyVM.getMDQuantityUnits()
            }
            if grocyVM.mdQuantityUnits.isEmpty {
                Text("Keine Mengeneinheiten gefunden. Füge welche hinzu.")
            }
            ForEach(grocyVM.mdQuantityUnits, id:\.id) {quantityUnit in
                MDQuantityUnitsRowView(quantityUnit: quantityUnit)
            }
            .onDelete(perform: deleteQuantityUnits)
            //            Button("+Add"){showAddQuantityUnit=true}
            //            Button("-Delete"){editMode = .active}
        }
        .onAppear(perform: grocyVM.getMDQuantityUnits)
        .animation(.default)
        .navigationBarTitle("Mengeneinheiten")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack{
                    if !grocyVM.mdQuantityUnits.isEmpty { EditButton() }
                    if !editMode.isEditing {
                        Button(action: {
                            showAddQuantityUnit = true
                        }, label: {Image(systemName: "text.badge.plus")})
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: self.$showAddQuantityUnit, content: { MDAddQuantityUnitView(isShown: self.$showAddQuantityUnit) })
    }
}

struct MDQuantityUnitsView_Previews: PreviewProvider {
    static var previews: some View {
        MDQuantityUnitsView()
    }
}
