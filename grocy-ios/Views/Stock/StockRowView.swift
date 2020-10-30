//
//  StockRowView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 29.10.20.
//

import SwiftUI

struct StockRowView: View {
    @StateObject private var grocyVM = GrocyViewModel()
    
    var stockElement: StockElement
    
    var body: some View {
        VStack(alignment: .leading){
            Text(stockElement.product.name).font(.title)
            HStack{
                Text("\(stockElement.amount) (\(stockElement.amountOpened) geöffnet)")
                Text("Nächstes MHD: \(formatDateOutput(stockElement.bestBeforeDate))")
//                Text("Standort: \(grocyVM.mdLocations.first(where: { $0.id ==  stockElement.product.locationID})?.name ?? "Fehler")")
            }
            .font(.caption)
        }
    }
}

//struct StockRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockRowView(stockElement: StockElement(amount: 3, amountAggregated: "3", bestBeforeDate: "2020-12-12", amountOpened: "2", amountOpenedAggregated: "2", isAggregatedAmount: "false", productID: "3", product: MDProduct(id: <#T##String#>, name: <#T##String#>, mdProductDescription: <#T##String#>, locationID: <#T##String#>, quIDPurchase: <#T##String#>, quIDStock: <#T##String#>, quFactorPurchaseToStock: <#T##String#>, barcode: <#T##String#>, minStockAmount: <#T##String#>, defaultBestBeforeDays: <#T##String#>, rowCreatedTimestamp: <#T##String#>, productGroupID: <#T##String#>, pictureFileName: <#T##String?#>, defaultBestBeforeDaysAfterOpen: <#T##String#>, allowPartialUnitsInStock: <#T##String#>, enableTareWeightHandling: <#T##String#>, tareWeight: <#T##String#>, notCheckStockFulfillmentForRecipes: <#T##String#>, parentProductID: <#T##String?#>, calories: <#T##String#>, cumulateMinStockAmountOfSubProducts: <#T##String#>, defaultBestBeforeDaysAfterFreezing: <#T##String#>, defaultBestBeforeDaysAfterThawing: <#T##String#>, shoppingLocationID: <#T##String#>, userfields: <#T##String?#>)))
//    }
//}
