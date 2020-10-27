//
//  MDProductGroupsView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct MDProductGroupsRowView: View {
    var productGroup: MDProductGroup
    
    var body: some View {
        VStack(alignment: .leading){
            Text(productGroup.name)//.font(.title)
            if !productGroup.mdProductGroupDescription.isEmpty {
                Text(productGroup.mdProductGroupDescription).font(.caption)
            }
        }
    }
}

struct MDProductGroupsView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @State private var editMode : EditMode = .inactive
    @State private var showAddProductGroup = false
    
    func deleteProductGroup(at offsets: IndexSet) {
        for offset in offsets {
            grocyVM.deleteMDObject(object: .product_groups, id: grocyVM.mdProductGroups[offset].id)    
        }
        grocyVM.getMDProductGroups()
    }
    
    var body: some View {
        List(){
            Button("__Load ProductGroups"){
                grocyVM.getMDProductGroups()
            }
            if grocyVM.mdProductGroups.isEmpty {
                Text("Keine Produktgruppen gefunden. Füge welche hinzu.")
            }
            ForEach(grocyVM.mdProductGroups, id:\.id) {productGroup in
                MDProductGroupsRowView(productGroup: productGroup)
            }
            .onDelete(perform: deleteProductGroup)
//            Button("+Add"){showAddProductGroup=true}
//            Button("-Delete"){editMode = .active}
        }
        .onAppear(perform: grocyVM.getMDProductGroups)
        .animation(.default)
        .navigationBarTitle("Produktgruppen")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack{
                    if !grocyVM.mdProductGroups.isEmpty { EditButton() }
                    if !editMode.isEditing {
                        Button(action: {
                            showAddProductGroup = true
                        }, label: {Image(systemName: "text.badge.plus")})
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: self.$showAddProductGroup, content: { MDAddProductGroupView(isShown: self.$showAddProductGroup) })
    }
}

struct MDProductGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        MDProductGroupsView()
    }
}

