//
//  StockEntriesListView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 26.10.20.
//

import SwiftUI

struct StockEntriesListView: View {
    @StateObject private var grocyVM = GrocyViewModel()
    
    var product: MDProduct
    
    var currentQuantityUnit: MDQuantityUnit {
        getQuantityUnit() ?? MDQuantityUnit(id: "0", name: "Stück", mdQuantityUnitDescription: "", rowCreatedTimestamp: "", namePlural: "Stücke", pluralForms: nil, userfields: nil)
    }
    
    func getQuantityUnit() -> MDQuantityUnit? {
        let quIDP = grocyVM.mdProducts.first(where: {$0.id == product.id})?.quIDPurchase
        let qu = grocyVM.mdQuantityUnits.first(where: {$0.id == quIDP})
        return qu
    }
    
    var body: some View {
        List() {
            ForEach(grocyVM.stockProductEntries[product.id] ?? [], id:\.id) { productEntry in
                VStack(alignment: .leading) {
                    Text("\(productEntry.amount) \(productEntry.amount == "1" ? currentQuantityUnit.name : currentQuantityUnit.namePlural) \(productEntry.stockEntryOpen != "0" ? " (\(productEntry.stockEntryOpen) offen)" : "")").font(.title)
                    Text("MHD: \(formatDateOutput(productEntry.bestBeforeDate)), Kauf: \(formatDateOutput(productEntry.purchasedDate))")
                    Text("Ort: \(grocyVM.mdLocations.first(where: { $0.id == productEntry.locationID })?.name ?? "Standortfehler")")
                }
            }
        }
        .navigationTitle("Bestand")
        .onAppear(perform: {
            grocyVM.getProductEntries(productID: product.id)
            grocyVM.getMDLocations()
        })
    }
}

//struct StockEntriesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockEntriesListView(product: MDProduct(id: "3", name: "Test", mdProductDescription: <#T##String#>, locationID: <#T##String#>, quIDPurchase: <#T##String#>, quIDStock: <#T##String#>, quFactorPurchaseToStock: <#T##String#>, barcode: <#T##String#>, minStockAmount: <#T##String#>, defaultBestBeforeDays: <#T##String#>, rowCreatedTimestamp: <#T##String#>, productGroupID: <#T##String#>, pictureFileName: <#T##String?#>, defaultBestBeforeDaysAfterOpen: <#T##String#>, allowPartialUnitsInStock: <#T##String#>, enableTareWeightHandling: <#T##String#>, tareWeight: <#T##String#>, notCheckStockFulfillmentForRecipes: <#T##String#>, parentProductID: <#T##String?#>, calories: <#T##String#>, cumulateMinStockAmountOfSubProducts: <#T##String#>, defaultBestBeforeDaysAfterFreezing: <#T##String#>, defaultBestBeforeDaysAfterThawing: <#T##String#>, shoppingLocationID: <#T##String#>, userfields: <#T##String?#>))
//    }
//}
