//
//  FingerprintViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 03/04/18.
//  Copyright © 2018 ZeroWaste. All rights reserved.
//

import UIKit
import PopupDialog
import BiometricAuthentication
import SwiftyJSON
import Luminous
import LocalAuthentication

class FingerprintViewController: UIViewController {
    @IBOutlet weak var biometricImage: UIImageView!
    
    var resultJSON = JSON()
    @IBAction func fingerprintSkipBtnPressed(_ sender: Any) {
        // Prepare the popup assets
        let title = "fingerprint_info".localized
        let message = "skip_info".localized
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized) {
            UserDefaults.standard.set(false, forKey: "fingerprint")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
            self.resultJSON["Fingerprint Scanner"].int = 0
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
    
    
    @IBAction func scanFingerprintBtnPressed(_ sender: Any) {
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            UserDefaults.standard.set(true, forKey: "fingerprint")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
            self.resultJSON["Fingerprint Scanner"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            // authentication successful
            
        }, failure: { [weak self] (error) in
            
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem {
                return
            }
                
                // device does not support biometric (face id or touch id) authentication
            else if error == .biometryNotAvailable {
                print(error.message())
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // show alternatives on fallback button clicked
            else if error == .fallback {
                
                // here we're entering username and password
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // No biometry enrolled in this device, ask user to register fingerprint or face
            else if error == .biometryNotEnrolled {
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // Biometry is locked out now, because there were too many failed attempts.
                // Need to enter device passcode to unlock.
            else if error == .biometryLockedout {
                // show passcode authentication
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // show error on authentication failed
            else {
                UserDefaults.standard.set(false, forKey: "fingerprint")
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
                self?.resultJSON["Fingerprint Scanner"].int = 0
                vc.resultJSON = (self?.resultJSON)!
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        })
        
    }
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        if BioMetricAuthenticator.canAuthenticate() {
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                print("hello faceid available")
                // device supports face id recognition.
                let yourImage: UIImage = UIImage(named: "face-id")!
                self.biometricImage.image = yourImage
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            UserDefaults.standard.set(true, forKey: "fingerprint")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
            self.resultJSON["Fingerprint Scanner"].int = 1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            // authentication successful
            
        }, failure: { [weak self] (error) in
            
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem {
                return
            }
                
                // device does not support biometric (face id or touch id) authentication
            else if error == .biometryNotAvailable {
                print(error.message())
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // show alternatives on fallback button clicked
            else if error == .fallback {
                
                // here we're entering username and password
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // No biometry enrolled in this device, ask user to register fingerprint or face
            else if error == .biometryNotEnrolled {
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // Biometry is locked out now, because there were too many failed attempts.
                // Need to enter device passcode to unlock.
            else if error == .biometryLockedout {
                // show passcode authentication
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
            }
                
                // show error on authentication failed
            else {
                UserDefaults.standard.set(false, forKey: "fingerprint")
                self?.view.makeToast("\(error.message())", duration: 2.0, position: .bottom)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
                self?.resultJSON["Fingerprint Scanner"].int = 0
                vc.resultJSON = (self?.resultJSON)!
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        })
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
