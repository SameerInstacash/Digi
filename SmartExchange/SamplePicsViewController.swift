//
//  SamplePicsViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 25/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit

class SamplePicsViewController: UIViewController {
    
    var productName = ""
    var productImage = ""
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckVC") as! CheckConditionViewController
        vc.productName = self.productName
        vc.productImage = self.productImage
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
