//
//  StockFilterView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 29.10.20.
//

import SwiftUI

private struct StockFilterItemView: View {
    var num: Int
    //    var description: String
    @Binding var filteredStatus: ProductStatus
    var ownFilteredStatus: ProductStatus
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            if filteredStatus != ownFilteredStatus {
                filteredStatus = ownFilteredStatus
            } else {
                filteredStatus = ProductStatus.all
            }
        }, label: {
            HStack{
                if filteredStatus == ownFilteredStatus {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                Text("\(String(num)) \(ownFilteredStatus.rawValue)")
            }
            .padding(7)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(30)
            .lineLimit(1)
        })
    }
}

struct StockFilterView: View {
    @Binding var filteredStatus: ProductStatus
    
    var numExpiringSoon: Int
    var numExpired: Int
    var numBelowStock: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                StockFilterItemView(num: numExpiringSoon, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.expiringSoon, backgroundColor: Color.yellow)
                StockFilterItemView(num: numExpired, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.expired, backgroundColor: Color.red)
                StockFilterItemView(num: numBelowStock, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.belowMinStock, backgroundColor: Color.blue)
            }
        }
    }
}

//struct StockFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockFilterView()
//    }
//}
