//
//  MDProductView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDProductsRowView: View {
    var product: MDProduct
    
    var body: some View {
        VStack(alignment: .leading){
            Text(product.name)//.font(.headline)
            HStack{
                if let loc = GrocyViewModel.shared.mdLocations.firstIndex { $0.id == product.locationID } {
                    Text("Standort: ")
                        +
                        Text(GrocyViewModel.shared.mdLocations[loc].name)
                }
                if let pg = GrocyViewModel.shared.mdProductGroups.firstIndex { $0.id == product.productGroupID } {
                    Text("Kategorie: ")
                        +
                        Text(GrocyViewModel.shared.mdProductGroups[pg].name)
                }
            }
            if !product.mdProductDescription.isEmpty {
                Text(product.mdProductDescription).font(.caption)
//                HTMLText(htmlText: product.mdProductDescription)
//                HTMLText(width: 80, htmlText: product.mdProductDescription)
            }
        }
    }
}

struct MDProductsView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @State private var editMode : EditMode = .inactive
    @State private var showAddProduct = false
    
    private func deleteProduct(at offsets: IndexSet) {
        for offset in offsets {
            grocyVM.deleteMDObject(object: .products, id: grocyVM.mdProducts[offset].id)
        }
        grocyVM.getMDProducts()
    }
    
    var body: some View {
        List(){
            Button("Lade Produkte") {
                grocyVM.getMDLocations()
                grocyVM.getMDProductGroups()
                grocyVM.getMDProducts()
            }
            if grocyVM.mdProducts.isEmpty {
                Text("Keine Produkte gefunden. Füge welche hinzu.")
            }
            ForEach(grocyVM.mdProducts, id:\.id) {product in
                MDProductsRowView(product: product)
            }
            .onDelete(perform: deleteProduct)
//            Button("+Add"){showAddProduct = true}
//            Button("-Delete"){editMode = .active}
        }
        .animation(.default)
        .navigationBarTitle("Produkte")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack{
                    if !grocyVM.mdProducts.isEmpty { EditButton() }
                    if !editMode.isEditing {
                        Button(action: {
                            showAddProduct = true
                        }, label: {Image(systemName: "text.badge.plus")})
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: self.$showAddProduct, content: { MDAddProductView(isShown: self.$showAddProduct) })
        .onAppear(perform: {
            grocyVM.getMDProducts()
            grocyVM.getMDLocations()
            grocyVM.getMDProductGroups()
        })
    }
}

struct MDProductsView_Previews: PreviewProvider {
    static var previews: some View {
        MDProductsView()
    }
}

