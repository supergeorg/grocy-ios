//
//  MDAddShoppingLocationView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 14.10.20.
//

import SwiftUI

struct MDAddShoppingLocationView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @Binding var isShown: Bool
    
    @State var name: String = ""
    @State var mdShoppingLocationDescription: String = ""
    
    private func findNextID() -> Int {
        let ints = grocyVM.mdShoppingLocations.map{ Int($0.id) }
        var startvar = 0
        while ints.contains(startvar){startvar += 1}
        return startvar
    }
    
    private func addShoppingLocation() {
        grocyVM.postMDObject(object: .shopping_locations, content: MDShoppingLocationPOST(id: findNextID(), name: name, mdShoppingLocationDescription: mdShoppingLocationDescription, rowCreatedTimestamp: Date().iso8601withFractionalSeconds, userfields: nil))
        grocyVM.getMDShoppingLocations()
    }
    
    var body: some View {
        NavigationView() {
            Form {
                Section(header: Text("Geschäftsinfo")){
                    HStack{
                        Image(systemName: "tag")
                        TextFieldWithDescription(textToEdit: $name, description: "Geschäftsname", disableAutoCorrection: true)
                        Image(systemName: !name.isEmpty ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        Image(systemName: "text.justifyleft")
                        TextFieldWithDescription(textToEdit: $mdShoppingLocationDescription, description: "Geschäftsbeschreibung")
                    }
                }
            }
            .animation(.default)
            .navigationBarTitle("Geschäft hinzufügen")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        self.isShown = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Geschäft speichern") {
                        addShoppingLocation()
                        self.isShown = false
                    }.disabled(name.isEmpty)
                }
            })
        }
    }
}

struct MDAddShoppingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        MDAddShoppingLocationView(grocyVM: GrocyViewModel.shared, isShown: Binding.constant(true), name: "Name", mdShoppingLocationDescription: "Beschreibung")
    }
}
