//
//  File.swift
//  calhacks_receipt_split
//
//  Created by Benjamin Pust on 11/3/18.
//  Copyright © 2018 Benjamin Pust. All rights reserved.
//

import Foundation

class ReceiptItem {
    
    var name: String
    var cost: Float
    
    init(name: String, cost: Float) {
        self.name = name
        self.cost = cost
    }
}
