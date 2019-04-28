//
//  ViewController.swift
//  TestApplication
//
//  Created by Aayush Maheshwari on 26/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import UIKit
import PinboardManager
import SwiftyJSON
class PinBoardViewController: UITableViewController {

    let notificationName = Notification.Name("DidReceivePins")
    var pins = [Pin]()
    let pinsViewModel = PinsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        pinsViewModel.fetchPins()
        pinsViewModel.notificationName = notificationName
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: notificationName, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateUI(_ notification: NSNotification) {
        
        if (notification.userInfo?["error"] as? NSError) != nil {
            return
        }
        self.pins = pinsViewModel.pins
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pin = pins[indexPath.row]
        
        if let cell = cell as? PinTableViewCell {
            cell.PinImageView.image = pin.urls?.smallImage
            cell.userName.text = pin.user?.name
        }
        return cell
    }
}

class PinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var PinImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
}
