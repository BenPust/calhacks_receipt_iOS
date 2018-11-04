//
//  OrderTableViewCell.swift
//  calhacks_receipt_split
//
//  Created by Benjamin Pust on 11/3/18.
//  Copyright © 2018 Benjamin Pust. All rights reserved.
//

import UIKit

protocol OrderTableViewCellDelegate:class {
    func didClickCellItem(sender: OrderTableViewCell)
}

class OrderTableViewCell: UITableViewCell {

    var receiptItem: ReceiptItem!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    
    weak var delegate: OrderTableViewCellDelegate!
    
    @IBAction func addedItem(_ sender: Any) {
        delegate.didClickCellItem(sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
