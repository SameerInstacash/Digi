//
//  TnCViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 24/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit
import BEMCheckBox

class TnCViewController: UIViewController {
    
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var tncTextView: UITextView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var productName = ""
    var productImage = ""
        
    @IBAction func continuebtnclicked(_ sender: Any) {
        if(checkBox.on) {
            call()
        }else{
            self.view.makeToast("Please Accept terms to continue", duration: 2.0, position: .bottom)
        }
    }
    
    
    func call(){
        DispatchQueue.main.async() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckVC") as! CheckConditionViewController
            vc.productName = self.productName
            vc.productImage = self.productImage
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
            
            self.tncTextView.text = "1. You are required to sign a new Phone Freedom 365 contract with Digi, as part of this Device Upgrade exercise.\n2. You are the legal owner of this device. If the device is found to be lost, stolen or blacklisted, you will be liable to make a full refund of the device’s value within seven (7) working days, failing which, necessary legal actions will be taken without any reference made to you for which you shall be further liable to the necessary costs incurred.\n3. Upon the handover of device, the ownership of the device shall be transferred to Digi with immediate effect and cannot be returned to the customer for any reason.\n4. You shall perform a factory reset on the device and remove any personal locks (e.g. Apple ID, Find My iPhone, Samsung Account, Google Account) before handover of device.\n5. Any remaining data in the device shall be considered destroyed and cannot be recovered.\n6. You declare that the said device has not been lost or stolen, was not purchased with government funds, and is not government’s property. No trade value shall be afforded to any device reported as lost or stolen, purchased with government funds, or is constituted as the government’s property.\n7. The condition, specifications, and other representations that you have provided with regards to the said device are true and accurate.\n8. You shall be responsible to ensure that the SIM card/ memory card has been removed before handover of device.\n9. You agree and acknowledge that device’s quoted value offered on the website shall be subject to the Company’s assessment, evaluation and discretion."
            
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            
            self.tncTextView.text = "1. You are the legal owner of this device. If the device is found to be lost, stolen or blacklisted, you will be liable to make a full refund of the device’s value within seven (7) working days, failing which, necessary legal actions will be taken without any reference made to you for which you shall be further liable to the necessary costs incurred.\n2. Upon the handover of device, the ownership of the device shall be transferred to Digi with immediate effect and cannot be returned to the customer for any reason.\n3. You shall perform a factory reset on the device and remove any personal locks (e.g. Apple ID, Find My iPhone, Samsung Account, Google Account) before handover of device.\n4. Any remaining data in the device shall be considered destroyed and cannot be recovered.\n5. You declare that the said device has not been lost or stolen, was not purchased with government funds, and is not government’s property. No trade value shall be afforded to any device reported as lost or stolen, purchased with government funds, or is constituted as the government’s property.\n6. The condition, specifications, and other representations that you have provided with regards to the said device are true and accurate.\n7. You shall be responsible to ensure that the SIM card/ memory card has been removed before handover of device.\n8. You agree and acknowledge that device’s quoted value offered on the website shall be subject to the Company’s assessment, evaluation and discretion."
            
        }
        
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
