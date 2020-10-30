//
//  StockView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import SwiftUI

struct FilterSettingView: View {
    var name: String
    var selection: String
    
    var body: some View {
        HStack{
            Image(systemName: "line.horizontal.3.decrease.circle")
            VStack{
                Text(name)
                    .font(.body)
                    .foregroundColor(.primary)
                Text(selection)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct StockView: View {
    @StateObject private var grocyVM = GrocyViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShowingSheet: Bool = false
    
    @State private var showSearch: Bool = false
    @State private var showFilter: Bool = false
    
    @State private var searchString: String = ""
    
    @State private var filteredLocation: String = ""
    @State private var filteredProductGroup = ""
    @State private var filteredStatus: ProductStatus = .all
    
    private enum InteractionSheet: Identifiable {
        case none, buy, consume, transfer
        var id: Int {
            self.hashValue
        }
    }

    @State private var activeSheet: InteractionSheet = .none
    
    var numExpiringSoon: Int {
        grocyVM.stock
            .filter {
                (0..<6) ~= (getTimeDistanceFromString($0.bestBeforeDate) ?? 100)
            }
            .count
    }
    
    var numExpired: Int {
        grocyVM.stock
            .filter {
                (getTimeDistanceFromString($0.bestBeforeDate) ?? 100) < 0
            }
            .count
    }
    
    var numBelowStock: Int {
        grocyVM.stock
            .filter {
                Int($0.amount) ?? 1 < Int($0.product.minStockAmount) ?? 0
            }
            .count
    }
    
    var filteredProducts: Stock {
        grocyVM.stock
            .filter {
                filteredStatus == .expiringSoon ? ((0..<5) ~= getTimeDistanceFromString($0.bestBeforeDate) ?? 100) : true
            }
            .filter {
                filteredStatus == .expired ? (getTimeDistanceFromString($0.bestBeforeDate) ?? 100 < 0) : true
            }
            .filter {
                filteredStatus == .belowMinStock ? Int($0.amount) ?? 1 < Int($0.product.minStockAmount) ?? 0 : true
            }
            .filter {
                !filteredLocation.isEmpty ? $0.product.locationID == filteredLocation : true
            }
            .filter {
                !filteredProductGroup.isEmpty ? $0.product.productGroupID == filteredProductGroup : true
            }
            .filter {
                !searchString.isEmpty ? $0.product.name.localizedCaseInsensitiveContains(searchString) : true
            }
    }
    
    var body: some View {
        NavigationView(){
            List() {
                if showFilter {
                    HStack{
                        Picker(selection: $filteredLocation, label: FilterSettingView(name: "Standort", selection: filteredLocation.isEmpty ? "Alle" : grocyVM.mdLocations.first(where: {$0.id == filteredLocation})?.name ?? "Fehler"),content: {
                            Text("Alle").tag("")
                            ForEach(grocyVM.mdLocations, id:\.id) { location in
                                Text(location.name).tag(location.id)
                            }
                        }).pickerStyle(MenuPickerStyle())
                        Spacer()
                        Picker(selection: $filteredProductGroup, label: FilterSettingView(name: "Produktgruppe", selection: filteredProductGroup.isEmpty ? "Alle" : grocyVM.mdProductGroups.first(where: {$0.id == filteredProductGroup})?.name ?? "Fehler"), content: {
                            Text("Alle").tag("")
                            ForEach(grocyVM.mdProductGroups, id:\.id) { productGroup in
                                Text(productGroup.name).tag(productGroup.id)
                            }
                        }).pickerStyle(MenuPickerStyle())
                        Spacer()
                        Picker(selection: $filteredStatus, label: FilterSettingView(name: "Status", selection: filteredStatus.rawValue), content: {
                            Text(ProductStatus.all.rawValue).tag(ProductStatus.all)
                            Text(ProductStatus.expiringSoon.rawValue).tag(ProductStatus.expiringSoon)
                            Text(ProductStatus.expired.rawValue).tag(ProductStatus.expired)
                            Text(ProductStatus.belowMinStock.rawValue).tag(ProductStatus.belowMinStock)
                        }).pickerStyle(MenuPickerStyle())
                    }
                } else {
                    StockFilterView(filteredStatus: $filteredStatus, numExpiringSoon: numExpiringSoon, numExpired: numExpired, numBelowStock: numBelowStock)
                }
                if showSearch {
                    SearchBar(text: $searchString, placeholder: "Suche")
                }
                if grocyVM.stock.isEmpty {
                    Text("Nichts auf Lager.").padding()
                }
                //                Button("tr") {showTransferProduct = true}
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
            .onAppear(perform: {
                grocyVM.getStock()
                grocyVM.getMDLocations()
                grocyVM.getMDProductGroups()
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack{
                        Button(action: {
                            grocyVM.getStock()
                            grocyVM.getMDLocations()
                            grocyVM.getMDProductGroups()
                        }, label: {Image(systemName: "arrow.triangle.2.circlepath.circle")})
                        Button(action: {
                            showFilter.toggle()
                        }, label: {Image(systemName: showFilter ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")})
                        Button(action: {
                            showSearch.toggle()
                        }, label: {Image(systemName: showSearch ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")})
                        Button(action: {
                            self.activeSheet = .transfer
                            self.isShowingSheet.toggle()
                        }, label: {Image(systemName: "arrow.left.arrow.right")})
                        Button(action: {
                            self.activeSheet = .consume
                            self.isShowingSheet.toggle()
                        }, label: {Image(systemName: "envelope.open")})
                        Button(action: {
                            activeSheet = .buy
                            self.isShowingSheet.toggle()
                        }, label: {Image(systemName: "cart.badge.plus")})
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSheet, content: {
            switch activeSheet {
            case .buy:
                BuyProductView()
            case .consume:
                ConsumeProductView()
            case .transfer:
                TransferProductView()
            case .none:
                EmptyView()
            }
        })
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
    }
}
