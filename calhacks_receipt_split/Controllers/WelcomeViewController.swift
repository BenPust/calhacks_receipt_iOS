//
//  ViewController.swift
//  calhacks_receipt_split
//
//  Created by Benjamin Pust on 11/3/18.
//  Copyright © 2018 Benjamin Pust. All rights reserved.
//

import UIKit
import WeScan

class WelcomeViewController: UIViewController {

    struct User {
        var name: String
        var date: Date
    }
    
    @IBOutlet weak var tableView: UITableView!
    var tmpUsers = [User(name: "Ben and Xavier paid Oscar for Bongo", date: Date()),
                    User(name: "Oscar and Xavier paid Ben for Bongo", date: Date()),
                    User(name: "Xavier", date: Date()),
                    User(name: "Dominic", date: Date()),
                    ]
    
    @IBOutlet weak var startCameraBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startCameraScan(_ sender: Any) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        self.present(scannerVC, animated: true)   
    }
}

// MARK: - We Scan Delegate

extension WelcomeViewController: ImageScannerControllerDelegate {
    // Somewhere on your ViewController that conforms to ImageScannerControllerDelegate
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
        performSegue(withIdentifier: "toOrder", sender: nil)
        
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}

extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.mainLabel.text = tmpUsers[indexPath.row].name
        cell.dateLabel.text = tmpUsers[indexPath.row].date.toString()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
