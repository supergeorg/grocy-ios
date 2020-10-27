//
//  MDAddLocationView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDAddLocationView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @Binding var isShown: Bool
    
    @State var name: String = ""
    @State var mdLocationDescription: String = ""
    @State var isFreezer: Bool = false
    
    private func findNextID() -> Int {
        let ints = grocyVM.mdLocations.map{ Int($0.id) }
        var startvar = 0
        while ints.contains(startvar){startvar += 1}
        return startvar
    }
    
    private func addLocation() {
        grocyVM.postMDObject(object: .locations, content: MDLocationPOST(id: findNextID(), name: name, mdLocationDescription: mdLocationDescription, rowCreatedTimestamp: Date().iso8601withFractionalSeconds, isFreezer: String(isFreezer), userfields: nil))
        grocyVM.getMDLocations()
    }
    
    var body: some View {
        NavigationView() {
            Form {
                Section(header: Text("Standortinfo")){
                    HStack{
                        Image(systemName: "tag")
                        TextFieldWithDescription(textToEdit: $name, description: "Standortname", disableAutoCorrection: true)
                        Image(systemName: !name.isEmpty ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .renderingMode(.original)
                    }
                    HStack{
                        Image(systemName: "text.justifyleft")
                        TextFieldWithDescription(textToEdit: $mdLocationDescription, description: "Standortbeschreibung")
                    }
                    
                }
                Section(header: Text("Gefrier-Standort")){
                    HStack{
                        Image(systemName: "thermometer.snowflake")
                        Toggle("Ist ein Gefrier-Standort", isOn: $isFreezer)
                    }
                    Text("Beim Umlagen von Produkten von/zu einem Gefrier-Standort wird das Mindesthaltbarkeitsdatum der Produkte automatisch entsprechend den Produkteinstellungen angepasst").font(.caption)
                }
            }
            .animation(.default)
            .navigationBarTitle("Standort hinzufügen")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        self.isShown = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Standort speichern") {
                        addLocation()
                        self.isShown = false
                    }.disabled(name.isEmpty)
                }
            })
        }
    }
}

struct MDAddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        MDAddLocationView(grocyVM: GrocyViewModel.shared, isShown: Binding.constant(true), name: "Beispielstandort", mdLocationDescription: "Beschreibung", isFreezer: false)
    }
}
