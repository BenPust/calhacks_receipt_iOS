//
//  Recipt.swift
//  calhacks_receipt_split
//
//  Created by Benjamin Pust on 11/3/18.
//  Copyright © 2018 Benjamin Pust. All rights reserved.
//

import Foundation

class Receipt {
    
    var restaurant: String
    var date: Date
    
    init(restaurant: String, date: Date) {
        self.restaurant = restaurant
        self.date = date
    }
}
