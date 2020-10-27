//
//  InteractionModes.swift
//  grocy-ios
//
//  Created by Georg Meissner on 27.10.20.
//

import Foundation

enum StockTransactionType: String {
    case purchase, consume
    case inventoryCorrection = "inventory-correction"
    case productOpened = "product-opened"
}
