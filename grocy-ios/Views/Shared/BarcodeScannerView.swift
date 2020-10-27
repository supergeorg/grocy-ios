//
//  BarcodeScannerView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 15.10.20.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String?
    
    @Binding var isShown: Bool
    @Binding var currentBarcode: String

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if self.scannedCode != nil {
                    Button("apply code") {
                        currentBarcode = scannedCode!
                        isShown = false
                    }
//                    NavigationLink("Next page", destination: BarcodeResultPage(scannedCode: scannedCode!), isActive: .constant(true)).hidden()
                }
                Button("Scan Code") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
                Text("Scan a QR code to begin")
            }

        }
    }

    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code
                    self.isPresentingScanner = false
                }
            }
        )
    }
}

//struct BarcodeScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarcodeScannerView()
//    }
//}
