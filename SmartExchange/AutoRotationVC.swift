//
//  AutoRotationVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 20/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON
import PopupDialog

class AutoRotationVC: UIViewController {

    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var AutoRotationText: UITextView!
    @IBOutlet weak var AutoRotationImage: UIImageView!
    @IBOutlet weak var AutoRotationImageView: UIImageView!
    var hasStarted = false
    var resultJSON = JSON()
    
    @IBAction func beginBtnClicked(_ sender: Any) {
        if hasStarted {
            // Prepare the popup assets
            let title = "rotation_info".localized
            let message = "skip_info".localized
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = CancelButton(title: "Yes".localized) {
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
                
                UserDefaults.standard.set(false, forKey: "rotation")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProximityView") as! ProximityVC
                self.resultJSON["Rotation"].int = 0
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
            
        }else{
            hasStarted = true
            AutoRotationText.text = "landscape_mode".localized
            beginBtn.setTitle("Skip".localized,for: .normal)
            AutoRotationImage.isHidden = true
            AutoRotationImageView.isHidden = false
            AutoRotationImageView.image = UIImage(named: "landscape_image")!
        }
    }
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        AutoRotationImage.loadGif(name: "rotation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
       @objc func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            AutoRotationText.text = "portrait_mode".localized
            AutoRotationImageView.image = UIImage(named: "portrait_image")!

        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            print("Portrait")
            UserDefaults.standard.set(true, forKey: "rotation")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProximityView") as! ProximityVC
            resultJSON["Rotation"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
           // let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
            //self.present(vc, animated: true, completion: nil)
        }
        
    }

   
}
