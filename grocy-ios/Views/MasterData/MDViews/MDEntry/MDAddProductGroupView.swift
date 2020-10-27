//
//  MDAddProductGroupView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 15.10.20.
//

import SwiftUI

struct MDAddProductGroupView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @Binding var isShown: Bool
    
    @State var name: String = ""
    @State var mdProductGroupDescription: String = ""
    
    private func findNextID() -> Int {
        let ints = grocyVM.mdProductGroups.map{ Int($0.id) }
        var startvar = 0
        while ints.contains(startvar){startvar += 1}
        return startvar
    }
    
    private func addProductGroup() {
        grocyVM.postMDObject(object: .product_groups, content: MDProductGroupPOST(id: findNextID(), name: name, mdProductGroupDescription: mdProductGroupDescription, rowCreatedTimestamp: Date().iso8601withFractionalSeconds, userfields: nil))
        grocyVM.getMDProductGroups()
    }
    
    var body: some View {
        NavigationView() {
            Form {
                Section(header: Text("Produktgruppe")){
                    HStack{
                        Image(systemName: "tag")
                        TextFieldWithDescription(textToEdit: $name, description: "Gruppenname", disableAutoCorrection: true)
                        Image(systemName: !name.isEmpty ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        Image(systemName: "text.justifyleft")
                        TextFieldWithDescription(textToEdit: $mdProductGroupDescription, description: "Gruppenbeschreibung")
                    }
                }
            }
            .navigationBarTitle("Neue Produktgruppe")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        self.isShown = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Produktgruppe speichern") {
                        addProductGroup()
                        self.isShown = false
                    }.disabled(name.isEmpty)
                }
            })
        }
    }
}

struct MDAddProductGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MDAddProductGroupView(grocyVM: GrocyViewModel.shared, isShown: Binding.constant(true), name: "Produktgruppenname", mdProductGroupDescription: "Produktgruppenbeschreibung")
    }
}

