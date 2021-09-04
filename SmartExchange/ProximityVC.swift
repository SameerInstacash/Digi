//
//  ProximityVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 19/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftyJSON

class ProximityVC: UIViewController {
    
    var resultJSON = JSON()

    @IBOutlet weak var proximityImageView: UIImageView!
    @IBOutlet weak var proximityText: UILabel!
    
    @IBAction func proXimitySkipPressed(_ sender: Any) {
        
        // Prepare the popup assets
        let title = "Proximity_Sensor_Diagnosis".localized
        let message = "skip_info".localized
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
            
            UserDefaults.standard.set(false, forKey: "proximity")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VRVC") as! VolumeRockerVC
            self.resultJSON["Proximity"].int = 0
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
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
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        
        proximityText.isHidden = false
        proximityImageView.loadGif(name: "proximity")
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector((self.proximityChanged)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }else {
            UserDefaults.standard.set(true, forKey: "proximity")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VRVC") as! VolumeRockerVC
            self.resultJSON["Proximity"].int = -2
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func proximityChanged(notification: NSNotification) {
        
        if (notification.object as? UIDevice) != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
            
            
            print("Proximity test passed")
            UserDefaults.standard.set(true, forKey: "proximity")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VRVC") as! VolumeRockerVC
            self.resultJSON["Proximity"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
//            let secondViewController:CameraViewController = CameraViewController()
//            self.present(secondViewController, animated: true, completion: nil)

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
