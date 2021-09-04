//
//  EarphoneJackVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 20/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import AVFoundation
import PopupDialog
import SwiftGifOrigin
import SwiftyJSON

class EarphoneJackVC: UIViewController {
    
    var resultJSON = JSON()
    @IBOutlet weak var earphoneInfoImage: UIImageView!
    @IBAction func earphoneSkipPressed(_ sender: Any) {
        // Prepare the popup assets
        let title = "earphone_info".localized
        let message = "skip_info".localized
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized) {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
            
            UserDefaults.standard.set(false, forKey: "earphone")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChargerVC") as! DeviceChargerVC
            self.resultJSON["Earphone"].int = 0
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
    
    
    let session = AVAudioSession.sharedInstance()
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        earphoneInfoImage.loadGif(name: "earphone_jack")
        
        let currentRoute = self.session.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphone plugged in")
                    
                } else {
                    print("headphone pulled out")
                }
            }
        } else {
            print("requires connection to device")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioRouteChangeListener),
            name: NSNotification.Name.AVAudioSessionRouteChange,
            object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc dynamic private func audioRouteChangeListener(notification:NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        
        switch audioRouteChangeReason {
        
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            print("headphone plugged in")
            UserDefaults.standard.set(true, forKey: "earphone")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChargerVC") as! DeviceChargerVC
            self.resultJSON["Earphone"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            break
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            print("headphone pulled out")
            UserDefaults.standard.set(true, forKey: "earphone")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChargerVC") as! DeviceChargerVC
            self.resultJSON["Earphone"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
    }

}
