//
//  StockEntriesListView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 26.10.20.
//

import SwiftUI

struct StockEntriesListView: View {
    @ObservedObject private var grocyVM = GrocyViewModel()
    
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
//                HStack {
//                    Text(productEntry.id)
//                    Text(productEntry.bestBeforeDate)
//                    Text(productEntry.purchasedDate)
//                }
//                "id": "1",
//                    "product_id": "3",
//                    "amount": "2",
//                    "best_before_date": "2020-10-28",
//                    "purchased_date": "2020-10-26",
//                    "stock_id": "5f96c7e0bbf52",
//                    "price": "5",
//                    "open": "0",
//                    "opened_date": null,
//                    "row_created_timestamp": "2020-10-26 13:58:08",
//                    "location_id": "0",
//                    "shopping_location_id": "0"
            }
        }
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
