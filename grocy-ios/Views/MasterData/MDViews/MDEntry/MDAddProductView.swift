//
//  MDAddProductView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//
// TODO Freezing und Tareweight

import SwiftUI

struct MDAddProductView: View {
    @ObservedObject var grocyVM: GrocyViewModel = .shared
    
    @Binding var isShown: Bool
    
    @State var showBarcodeScanner: Bool = false
    @State var currentBarcode: String = ""
    
    @State var name: String = "Produktname"
    @State var mdProductDescription: String = "Produktbeschreibung"
    @State var locationID: String = ""
    @State var shoppingLocationID: String = ""
    @State var quIDPurchase: String = ""
    @State var quIDStock: String = ""
    @State var quFactorPurchaseToStock: Int = 1
    @State var barcodes: Set<String> = ["2345", "2232"]
    @State var minStockAmount: Int = 0
    @State var defaultBestBeforeDays: Int = 0
    @State var productGroupID: String = "0"
    @State var defaultBestBeforeDaysAfterOpen: Int = 0
    @State var allowPartialUnitsInStock: Bool = false
    @State var enableTareWeightHandling: String = "0"
    @State var tareWeight: String = "0"
    @State var notCheckStockFulfillmentForRecipes: String = "0"
    @State var parentProductID: String = ""
    @State var calories: Double = 0.0
    @State var cumulateMinStockAmountOfSubProducts: Bool = false
    @State var defaultBestBeforeDaysAfterFreezing: String = "0"
    @State var defaultBestBeforeDaysAfterThawing: String = "0"
    
    private func findNextID() -> Int {
        let ints = grocyVM.mdProducts.map{ Int($0.id) }
        var startvar = 0
        while ints.contains(startvar){startvar += 1}
        return startvar
    }
    
    private func addProduct() {
        grocyVM
            .postMDObject(object: .products,
                          content: MDProductPOST(id: findNextID(),
                                                 name: name,
                                                 mdProductDescription: mdProductDescription,
                                                 locationID: locationID,
                                                 quIDPurchase: quIDPurchase,
                                                 quIDStock: quIDStock,
                                                 quFactorPurchaseToStock: String(quFactorPurchaseToStock),
                                                 barcode: barcodes.joined(separator: ","),
                                                 minStockAmount: String(minStockAmount),
                                                 defaultBestBeforeDays: String(defaultBestBeforeDays),
                                                 rowCreatedTimestamp: Date().iso8601withFractionalSeconds,
                                                 productGroupID: productGroupID,
                                                 pictureFileName: nil,
                                                 defaultBestBeforeDaysAfterOpen: String(defaultBestBeforeDaysAfterOpen),
                                                 allowPartialUnitsInStock: String(allowPartialUnitsInStock),
                                                 enableTareWeightHandling: enableTareWeightHandling,
                                                 tareWeight: tareWeight,
                                                 notCheckStockFulfillmentForRecipes: notCheckStockFulfillmentForRecipes,
                                                 parentProductID: nil,
                                                 calories: "",
                                                 cumulateMinStockAmountOfSubProducts: String(cumulateMinStockAmountOfSubProducts),
                                                 defaultBestBeforeDaysAfterFreezing: defaultBestBeforeDaysAfterFreezing,
                                                 defaultBestBeforeDaysAfterThawing: defaultBestBeforeDaysAfterThawing,
                                                 shoppingLocationID: shoppingLocationID,
                                                 userfields: nil))
        grocyVM.getMDProducts()
    }
    
    private struct BarcodeItemView: View {
        var bbarcode: String
        @Binding var bbarcodes: Set<String>
        
        var body: some View {
            HStack{
                Text(bbarcode)
                Button(action: {
                    bbarcodes.remove(bbarcode)
                }, label: {
                    Image(systemName: "xmark.circle")
                })
            }
            .padding(7)
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(30)
            .lineLimit(1)
        }
    }
    
    var body: some View {
        NavigationView() {
            Form {
                Section(header: Text("Produktinfo")){
                    HStack{
                        Image(systemName: "tag")
                        TextFieldWithDescription(textToEdit: $name, description: "Produktname", disableAutoCorrection: true)
                    }
                    HStack{
                        Image(systemName: "text.justifyleft")
                        TextFieldWithDescription(textToEdit: $mdProductDescription, description: "Beschreibung")
                    }
                }
                Section(header: Text("Barcodes")){
                    HStack{
                        Image(systemName: "barcode")
                        TextFieldWithDescription(textToEdit: $currentBarcode, description: "Barcode", disableAutoCorrection: true)
                        Button(action: {
                            if !currentBarcode.isEmpty {
                                barcodes.insert(currentBarcode)
                                currentBarcode = ""
                            }
                        }, label: {
                            Image(systemName: "plus")
                        })
                        Button(action: {
                            print("barcodescanner")
                            showBarcodeScanner = true
                        }, label: {
                            Image(systemName: "barcode.viewfinder")
                        })
                        .sheet(isPresented: $showBarcodeScanner, content: {
                            BarcodeScannerView(isShown: $showBarcodeScanner, currentBarcode: $currentBarcode)
                        })
                    }
                    if !barcodes.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(Array(barcodes), id:\.self) {barcode in
                                    BarcodeItemView(bbarcode: barcode, bbarcodes: $barcodes).id(UUID())
                                }
                            }.animation(.default)
                        }
                    }
                }
                Section(header: Text("Standardeinstellungen")){
                    HStack{
                        Image(systemName: "tag")
                        Picker("Standort", selection: $locationID, content: {
                            ForEach(grocyVM.mdLocations, id:\.id) { location in
                                Text(location.name).tag(location.id)
                            }
                        })
                        .onAppear(perform: grocyVM.getMDLocations)
                    }
                    HStack{
                        Image(systemName: "tag")
                        Picker("Geschäft", selection: $shoppingLocationID, content: {
                            ForEach(grocyVM.mdShoppingLocations, id:\.id) { shoppingLocation in
                                Text(shoppingLocation.name).tag(shoppingLocation.id)
                            }
                        })
                        .onAppear(perform: grocyVM.getMDShoppingLocations)
                    }
                }
                Section(header: Text("Haltbarkeit")){
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Standard Haltbarkeit in Tagen:").font(.caption)
                        HStack{
                            TextField("", value: $defaultBestBeforeDays, formatter: NumberFormatter())
                            Stepper(" Tage", onIncrement: {
                                defaultBestBeforeDays = defaultBestBeforeDays + 1
                            }, onDecrement: {
                                if defaultBestBeforeDays > -1 {
                                    defaultBestBeforeDays -= 1
                                }
                            })
                        }
                    }
                    Text("Bei Einkäufen wird hierauf basierend das MHD vorausgefüllt (-1 bedeuet, dass dieses Produkt niemals abläuft)").font(.caption)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Standard Haltbarkeit in Tagen nach dem Öffnen:").font(.caption)
                        HStack{
                            TextField("", value: $defaultBestBeforeDaysAfterOpen, formatter: NumberFormatter())
                            Stepper(" Tage", onIncrement: {
                                defaultBestBeforeDaysAfterOpen = defaultBestBeforeDaysAfterOpen + 1
                            }, onDecrement: {
                                if defaultBestBeforeDaysAfterOpen > 0 {
                                    defaultBestBeforeDaysAfterOpen -= 1
                                }
                            })
                        }
                    }
                    Text("Wenn dieses Produkt als geöffnet markiert wurde, wird das Mindesthaltbarkeitsdatum durch heute + diese Anzahl von Tagen ersetzt (ein Wert von 0 deaktiviert dies) ").font(.caption)
                }
                Section(header: Text("Mindestbestand")){
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mindestbestand:").font(.caption)
                        HStack{
                            TextField("Mindestbestand", value: $minStockAmount, formatter: NumberFormatter())
                            Stepper(" Stück", onIncrement: {
                                minStockAmount += 1
                            }, onDecrement: {
                                if minStockAmount > 0 {
                                    minStockAmount -= 1
                                }
                            })
                        }
                    }
                    Toggle("Mindestbestände von untergeordneten Produkten aufsummieren", isOn: $cumulateMinStockAmountOfSubProducts)
                    Text("Wenn aktiviert, werden die Mindestbestände von untergeordneten Produkten aufsummiert, heißt das untergeordnete Produkt wird nie 'fehlen', nur dieses").font(.caption)
                }
                Section(header: Text("Produkteigenschaften")) {
                    Picker("Produktgruppe", selection: $productGroupID, content: {
                        ForEach(grocyVM.mdProductGroups, id:\.id) { productGroup in
                            Text(productGroup.name).tag(productGroup.id)
                        }
                    }).onAppear(perform: grocyVM.getMDProductGroups)
                    Picker("Mengeneinheit Einkauf", selection: $quIDPurchase, content: {
                        ForEach(grocyVM.mdQuantityUnits, id:\.id) { quantityUnit in
                            Text(quantityUnit.name).tag(quantityUnit.id)
                        }
                    })
                    .onChange(of: quIDPurchase) { newID in
                        if quIDStock.isEmpty {
                            quIDStock = quIDPurchase
                        }
                    }
                    Picker("Mengeneinheit Bestand", selection: $quIDStock, content: {
                        ForEach(grocyVM.mdQuantityUnits, id:\.id) { quantityUnit in
                            Text(quantityUnit.name).tag(quantityUnit.id)
                        }
                    })
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Faktor Mengeneinheit Einkauf zu Mengeneinheit Bestand: ").font(.caption)
                        HStack{
                            TextField("Faktor Mengeneinheit Einkauf zu Mengeneinheit Bestand:", value: $quFactorPurchaseToStock, formatter: NumberFormatter())
                            Stepper(" Faktor", onIncrement: {
                                quFactorPurchaseToStock += 1
                            }, onDecrement: {
                                if quFactorPurchaseToStock > 1 {
                                    quFactorPurchaseToStock -= 1
                                }
                            })
                        }
                    }
                    if quFactorPurchaseToStock > 1 {
                        Text("Das bedeutet 1 im Einkauf entsprechen \(quFactorPurchaseToStock) im Bestand").font(.caption)
                    }
                    Toggle("Teilmengen im Bestand zulassen", isOn: $allowPartialUnitsInStock)
                    VStack(alignment: .leading, spacing: 2){
                        Text("Energie (kcal)").font(.caption)
                            +
                            Text(" pro Bestandsmengeneinheit").font(.caption)
                        HStack{
                            TextField("", value: $calories, formatter: NumberFormatter())
                            Stepper(" Faktor", onIncrement: {
                                calories += 0.01
                            }, onDecrement: {
                                if calories > 0 {
                                    calories -= 0.01
                                }
                            })
                        }
                    }
                }.onAppear(perform: grocyVM.getMDQuantityUnits)
            }
            .navigationBarTitle("Produkt")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        self.isShown = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Produkt speichern") {
                        addProduct()
                        self.isShown = false
                    }.disabled((name.isEmpty) || (locationID.isEmpty) || (quIDPurchase.isEmpty) || (quIDStock.isEmpty))
                }
            })
            .sheet(isPresented: $showBarcodeScanner, content: {
                CarBodeScannerView(showScanner: $showBarcodeScanner, barcodeText: $currentBarcode)
            })
        }
    }
}

struct MDAddProductView_Previews: PreviewProvider {
    static var previews: some View {
        MDAddProductView(grocyVM: GrocyViewModel.shared, isShown: Binding.constant(true), currentBarcode: "1234", name: "Name", mdProductDescription: "Beschreibung", locationID: "0", quIDPurchase: "0", quIDStock: "0", quFactorPurchaseToStock: 1, barcodes: ["5432", "999"], minStockAmount: 0, defaultBestBeforeDays: 0, productGroupID: "0", defaultBestBeforeDaysAfterOpen: 0, allowPartialUnitsInStock: false, enableTareWeightHandling: "0", tareWeight: "0", notCheckStockFulfillmentForRecipes: "0", parentProductID: "0", cumulateMinStockAmountOfSubProducts: false, defaultBestBeforeDaysAfterFreezing: "0", defaultBestBeforeDaysAfterThawing: "0")
    }
}

