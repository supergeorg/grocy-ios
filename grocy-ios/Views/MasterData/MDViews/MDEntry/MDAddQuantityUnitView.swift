//
//  MDAddQuantityUnitView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 15.10.20.
//

import SwiftUI

struct MDAddQuantityUnitView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @Binding var isShown: Bool
    
    @State var name: String = ""
    @State var namePlural: String = ""
    @State var mdQuantityUnitDescription: String = ""
    
    private func findNextID() -> Int {
        let ints = grocyVM.mdQuantityUnits.map{ Int($0.id) }
        var startvar = 0
        while ints.contains(startvar){startvar += 1}
        return startvar
    }
    
    private func addQuantityUnit() {
        grocyVM.postMDObject(object: .quantity_units, content: MDQuantityUnitPOST(id: findNextID(), name: name, mdQuantityUnitDescription: mdQuantityUnitDescription, rowCreatedTimestamp: Date().iso8601withFractionalSeconds, namePlural: namePlural, pluralForms: nil, userfields: nil))
        grocyVM.getMDQuantityUnits()
    }
    
    var body: some View {
        NavigationView() {
            Form {
                Section(header: Text("Mengeneinheit")){
                    HStack{
                        Image(systemName: "tray")
                        TextFieldWithDescription(textToEdit: $name, description: "Name in Einzahl", disableAutoCorrection: true)
                        Image(systemName: !name.isEmpty ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        Image(systemName: "tray.2")
                        TextFieldWithDescription(textToEdit: $namePlural, description: "Name in Mehrzahl", disableAutoCorrection: true)
                        Image(systemName: !namePlural.isEmpty ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        Image(systemName: "text.justifyleft")
                        TextFieldWithDescription(textToEdit: $mdQuantityUnitDescription, description: "Mengenbeschreibung")
                    }
                }
            }
            .animation(.default)
            .navigationBarTitle("Neue Mengeneinheit")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        self.isShown = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Mengeneinheit speichern") {
                        addQuantityUnit()
                        self.isShown = false
                    }.disabled((name.isEmpty) || (namePlural.isEmpty))
                }
            })
        }
    }
}

struct MDAddQuantityUnitView_Previews: PreviewProvider {
    static var previews: some View {
        MDAddQuantityUnitView(grocyVM: GrocyViewModel.shared, isShown: Binding.constant(true), name: "Name in Einzahl", namePlural: "Name in Mehrzahl", mdQuantityUnitDescription: "Mengenbeschreibung")
    }
}
