//
//  OrderViewController.swift
//  calhacks_receipt_split
//
//  Created by Benjamin Pust on 11/3/18.
//  Copyright © 2018 Benjamin Pust. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewController: UIViewController, OrderTableViewCellDelegate {
    
    // tmp
    
    var tmpReceipt = Receipt(restaurant: "Bongo", date: Date())
    
    var tmpUsers = [User(name: "Ben", id: "2"),
                    User(name: "Ben", id: "12"),
                    User(name: "Ben", id: "1"),
                    User(name: "Ben", id: "3")]
    
    var tmpItems = [ReceiptItem(name: "Bongo Burger", cost: 13.75),
                    ReceiptItem(name: "Bongo Burger", cost: 13.75),
                    ReceiptItem(name: "Bongo Burger", cost: 13.75),
                    ReceiptItem(name: "Bongo Burger", cost: 13.75),
                    ReceiptItem(name: "Fries", cost: 3.25),
                    ReceiptItem(name: "Fries", cost: 3.25),
                    ReceiptItem(name: "Fries", cost: 3.25)]
    
    //

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    var selectedIndices = [Int]()
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var finishButton: UIButton!
    var popupView: UIView!
    var viewIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initPopupView()
        
        restaurantNameLabel.text = tmpReceipt.restaurant
        dateLabel.text = tmpReceipt.date.toString()
    }
    
    func didClickCellItem(sender: OrderTableViewCell) {
        print("click ya bish", tableView.indexPath(for: sender)?.row)
        
        if selectedIndices.contains(tableView.indexPath(for: sender)!.row) {
            selectedIndices.remove(at: tableView.indexPath(for: sender)!.row)
            
            sender.addBtn.setTitleColor(UIColor(rgb: 0x3ECCE6), for: UIControl.State.normal)
            sender.addBtn.setTitle("✓", for: .normal)
            sender.addBtn.isEnabled = true
        } else {
            selectedIndices.append(tableView.indexPath(for: sender)!.row)
            
            sender.addBtn.setTitleColor(UIColor(rgb: 0xF24ED3), for: UIControl.State.normal)
            sender.addBtn.setTitle("↩︎", for: .normal)
//            sender.addBtn.isEnabled = false
        }
        
        
        if !viewIsShowing {
            pushPopupView()
            viewIsShowing = true
        }
        finishButton.setTitle("($\(calculateTotal())) Complete Payment", for: .normal)
        
        print(selectedIndices)
    }
    
    func calculateTotal() -> Float {
        let sum = selectedIndices.map({tmpItems[$0].cost}).reduce(0, +)
        return sum
    }

    @objc func didClickFinishButton(sender: UIButton) {
        
    }
}

// MARK: - Popup View

extension OrderViewController {
    func initPopupView() {
        print("here")
        
        let width = self.view.frame.width
        let height = self.view.frame.height / 9
        popupView = UIView(frame: CGRect(x: 0,
                                         y: self.view.frame.height,
                                         width: width,
                                         height: height))
        popupView.backgroundColor = .black
        
        finishButton = UIButton(frame: CGRect(x: width/10,
                                            y: 10,
                                            width: width - width/5,
                                            height: height / 2))
        
        finishButton.backgroundColor = .gray
        finishButton.setTitle("Complete Payment", for: .normal)
        finishButton.addTarget(self, action: #selector(didClickFinishButton), for: .touchUpInside)
        self.view.addSubview(popupView)
        popupView.addSubview(finishButton)
    }
    
    func pushPopupView() {
        let width = self.view.frame.width
        let height = self.view.frame.height / 9
        

//        if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window!.safeAreaInsets.bottom

        self.tableViewBottomConstraint.constant = -popupView.frame.height+bottomPadding
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.popupView.frame = CGRect(x: 0,
                                     y: self.view.frame.height - height,
                                     width: width,
                                     height: height)
        }
    }
}

// MARK: - TableView

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell", for: indexPath) as! OrderTableViewCell
        
        cell.delegate = self
        
        cell.orderNameLabel.text = tmpItems[indexPath.row].name
        cell.itemPriceLabel.text = String(tmpItems[indexPath.row].cost)
        cell.userNameLabel.text = "---"
        
        if selectedIndices.contains(indexPath.row) {
            cell.addBtn.setTitleColor(UIColor(rgb: 0xF24ED3), for: UIControl.State.normal)
            cell.addBtn.setTitle("↩︎", for: .normal)
//            cell.addBtn.isEnabled = false
        } else {
            cell.addBtn.setTitleColor(UIColor(rgb: 0x3ECCE6), for: UIControl.State.normal)
            cell.addBtn.setTitle("✓", for: .normal)
//            cell.addBtn.isEnabled = true
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - CollectionView

extension OrderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmpUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension OrderViewController {
    func getGroupRead() {
        Alamofire.request("", method: .post)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func postGroupRead() {
        Alamofire.request("", method: .post)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func postUserPickItem() {
        Alamofire.request("", method: .post)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getUserList() {
        Alamofire.request("", method: .post)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
}
