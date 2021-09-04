//
//  DeviceChargerVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 20/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import PopupDialog
import DKCamera
import SwiftGifOrigin
import SwiftyJSON

class DeviceChargerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var resultJSON = JSON()
    @IBOutlet weak var chargerInfoImage: UIImageView!
    @IBAction func chargerSkipPressed(_ sender: Any) {
        // Prepare the popup assets
        let title = "charger_info".localized
        let message = "skip_info".localized
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized) {
            DispatchQueue.main.async() {
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
                
                UserDefaults.standard.set(false, forKey: "charger")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
                self.resultJSON["USB"].int = 0
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        let buttonTwo = DefaultButton(title: "No".localized) {
            //Do Nothing
            popup.dismiss(animated: true, completion: nil)
        }
        
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        popup.dismiss(animated: true, completion: nil)
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Medium", size: 20)!
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 16)!
        
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.opacity         = 0.7
        ov.color           = .black
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        chargerInfoImage.loadGif(name: "charging")
        super.viewDidLoad()
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func batteryStateDidChange(notification: NSNotification){
        // The stage did change: plugged, unplugged, full charge...
        
        print("Device plugged in.")
        
        DispatchQueue.main.async() {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
            
            UserDefaults.standard.set(true, forKey: "charger")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
            self.resultJSON["USB"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    
    @objc func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
    }
    
}
