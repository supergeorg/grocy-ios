//
//  StockView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

private struct StockFilterItemView: View {
    var num: Int
    var description: String
    @Binding var isFiltering: Bool
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            isFiltering = !isFiltering
        }, label: {
            HStack{
                if isFiltering {
                    Image(systemName: "number")
                }
                Text(String(num))
                Text(description)
            }
            .padding(7)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(30)
            .lineLimit(1)
        })
    }
}

private struct StockFilterView: View {
    @Binding var isFilteringExpiringSoon: Bool
    @Binding var isFilteringExpired: Bool
    @Binding var isFilteringBelowMinStock: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                StockFilterItemView(num: 1, description: " expiring soon", isFiltering: $isFilteringExpiringSoon, backgroundColor: Color.yellow)
                StockFilterItemView(num: 1, description: " expired", isFiltering: $isFilteringExpired, backgroundColor: Color.red)
                StockFilterItemView(num: 1, description: " below min. stock amount", isFiltering: $isFilteringBelowMinStock, backgroundColor: Color.blue)
            }
        }
    }
}

struct StockRowView: View {
    var stockElement: StockElement
    
    var body: some View {
        VStack(alignment: .leading){
            Text(stockElement.product.name).font(.title)
            HStack{
                Text("\(stockElement.amount) (\(stockElement.amountOpened) geöffnet)")
                Text("Nächstes MHD: \(formatDateOutput(stockElement.bestBeforeDate))")
            }
                .font(.caption)
        }
    }
}

struct StockView: View {
    @ObservedObject private var grocyVM = GrocyViewModel()
    
    @State var showBuyProduct: Bool = false
    @State var showConsumeProduct: Bool = false
    
    @State var isFilteringExpiringSoon: Bool = false
    @State var isFilteringExpired: Bool = false
    @State var isFilteringBelowMinStock: Bool = false
    
    var filteredProducts: Stock {
        grocyVM.stock
            .filter {
                isFilteringExpiringSoon ? ((0..<5) ~= getTimeDistanceFromString($0.bestBeforeDate) ?? 100) : true
            }
            .filter {
                isFilteringExpired ? (getTimeDistanceFromString($0.bestBeforeDate) ?? 100 < 0) : true
            }
        //            .filter {
        //                isFilteringBelowMinStock ? getTimeDistanceFromString($0.bestBeforeDate) ?? 100 < 5 : true
        //            }
    }
    
    var body: some View {
        NavigationView(){
            List() {
                StockFilterView(isFilteringExpiringSoon: $isFilteringExpiringSoon, isFilteringExpired: $isFilteringExpired, isFilteringBelowMinStock: $isFilteringBelowMinStock)
                Button("Update Stock"){grocyVM.getStock()}
                if grocyVM.stock.isEmpty {
                    Text("Nichts auf Lager.").padding()
                }
                Button("buy"){showBuyProduct = true}
                Button("consume"){showConsumeProduct = true}
                ForEach(filteredProducts, id:\.productID) {stock in
                    NavigationLink(
                        destination: StockEntriesListView(product: stock.product),
                        label: {
                            StockRowView(stockElement: stock)
                        })
                }
            }.listStyle(InsetListStyle())
            .animation(.default)
            .navigationBarTitle("Stock")
            .onAppear(perform: grocyVM.getStock)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack{
                        Button(action: {
                            showConsumeProduct = true
                        }, label: {Image(systemName: "envelope.open")})
                        Button(action: {
                            showBuyProduct = true
                        }, label: {Image(systemName: "cart.badge.plus")})
                    }
                }
            }
            .sheet(isPresented: self.$showBuyProduct, content: { BuyProductView(isShown: self.$showBuyProduct) })
            .sheet(isPresented: self.$showConsumeProduct, content: { ConsumeProductView(isShown: self.$showConsumeProduct) })
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
    }
}
