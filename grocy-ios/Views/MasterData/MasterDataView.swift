//
//  MasterDataView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MasterDataView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    var body: some View {
        NavigationView(){
            List(){
                NavigationLink(destination: MDProductsView()) {
                    HStack{
                        Image(systemName: "archivebox")
                        Text("Produkte")
                    }
                }
                NavigationLink(destination: MDLocationsView()) {
                    HStack{
                        Image(systemName: "location")
                        Text("Standorte")
                    }
                }
                NavigationLink(destination: MDShoppingLocationsView()) {
                    HStack{
                        Image(systemName: "cart")
                        Text("Geschäfte")
                    }
                }
                NavigationLink(destination: MDQuantityUnitsView()) {
                    HStack{
                        Image(systemName: "number.circle")
                        Text("Mengeneinheiten")
                    }
                }
                NavigationLink(destination: MDProductGroupsView()) {
                    HStack{
                        Image(systemName: "lessthan.circle")
                        Text("Produktgruppen")
                    }
                }
            }
            .animation(.default)
            .navigationBarTitle("Stammdaten")
        }
    }
}

struct MasterDataView_Previews: PreviewProvider {
    static var previews: some View {
        MasterDataView()
    }
}
