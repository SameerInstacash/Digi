//
//  SmartExMainVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 16/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON
import Luminous

extension String {
    func withReplacedCharacters(_ oldChar: String, by newChar: String) -> String {
        let newStr = self.replacingOccurrences(of: oldChar, with: newChar, options: .literal, range: nil)
        return newStr
    }
}

class SmartExMainVC: UIViewController {

    var stringPassed = Data()
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var processLbl: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var productName = ""
    var productImage = ""
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        let device = Luminous.System.Hardware.Device.current
        productNameLabel.text = self.productName
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
            self.processLbl.text = "Welcome to Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            self.processLbl.text = "Welcome to Digi Trade-In"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
