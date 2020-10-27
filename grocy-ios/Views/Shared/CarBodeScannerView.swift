//
//  CarBodeScannerView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 20.10.20.
//

import SwiftUI
import CarBode
import AVFoundation

struct CarBodeScannerView: View {
    @Binding var showScanner: Bool
    @Binding var barcodeText: String
    
    var body: some View {
        VStack{
            CBScanner(
                supportBarcode: .constant([.code128]), //Set type of barcode you want to scan
                scanInterval: .constant(5.0), //Event will trigger every 5 seconds
                mockBarCode: .constant(BarcodeData(value:"12345", type: .code128))
            ){
                //When the scanner found a barcode
                barcodeText = $0.value
                showScanner = false
//                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
            }
            onDraw: {
                print("Preview View Size = \($0.cameraPreviewView.bounds)")
                print("Barcode Corners = \($0.corners)")
                
                //line width
                let lineWidth = 2
                
                //line color
                let lineColor = UIColor.red
                
                //Fill color with opacity
                //You also can use UIColor.clear if you don't want to draw fill color
                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                
                //Draw box
                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
            }
        }
    }
}

//struct CarBodeScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CarBodeScannerView()
//    }
//}
