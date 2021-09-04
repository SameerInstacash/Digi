//
//  VolumeRockerVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 19/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import JPSVolumeButtonHandler
import PopupDialog
import SwiftyJSON

class VolumeRockerVC: UIViewController {

    @IBOutlet weak var volumeUpImg: UIImageView!
    @IBOutlet weak var volumeDownImg: UIImageView!
    var resultJSON = JSON()
    
    @IBAction func volumeRockerSkipPressed(_ sender: Any) {
        // Prepare the popup assets
        let title = "hardware_info".localized
        let message = "skip_info".localized
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized) {
            self.tearDown()
            UserDefaults.standard.set(false, forKey: "volume")
//            let endPoint = UserDefaults.standard.string(forKey: "endpoint")!
//            if ((endPoint.contains("store-asia") || endPoint.contains("stores-asia") || endPoint.contains("asurionre") || endPoint.contains("seatest"))){
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EarphoneVC") as! EarphoneJackVC
//                self.resultJSON["Hardware Buttons"].int = 0
//                vc.resultJSON = self.resultJSON
//                self.present(vc, animated: true, completion: nil)
//            }else{
                UserDefaults.standard.set(true, forKey: "charger")
                UserDefaults.standard.set(true, forKey: "earphone")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
                self.resultJSON["Hardware Buttons"].int = 0
                self.resultJSON["Earphone"].int = 1
                self.resultJSON["USB"].int = 1
                vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
//            }
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
    

    
    var volDown = false
    var volUp = false
    private var volumeButtonHandler: JPSVolumeButtonHandler?
    
    var action: (() -> Void) = {} {
        didSet {
            // Is the handler already there, that is, is this module already in use?..
            if let handler = volumeButtonHandler {
                // ..If so, then add the action to the handler right away.
                handler.upBlock = action
                handler.downBlock = action
            }
            // Otherwise, just save the action here and see it added when the handler is created when the module goes into use (isInUse = true).
        }
    }
    

    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        
        volumeButtonHandler = JPSVolumeButtonHandler(
            up: {
                print("Volume up pressed")
                self.volumeUpImg.image = UIImage(named: "volume_up_green")
                self.volUp = true
                if(self.volDown == true){
                    print("Volume test passed")
                    self.tearDown()
                    UserDefaults.standard.set(true, forKey: "volume")
//                    let endPoint = UserDefaults.standard.string(forKey: "endpoint")!
//                    if (endPoint.contains("store-asia") || endPoint.contains("stores-asia") || endPoint.contains("asurionre") || endPoint.contains("seatest")){
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EarphoneVC") as! EarphoneJackVC
//                        self.resultJSON["Hardware Buttons"].int = 1
//                        vc.resultJSON = self.resultJSON
//                        self.present(vc, animated: true, completion: nil)
//                    }else{
                        UserDefaults.standard.set(true, forKey: "charger")
                        UserDefaults.standard.set(true, forKey: "earphone")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
                        self.resultJSON["Hardware Buttons"].int = 1
                        self.resultJSON["Earphone"].int = 1
                        self.resultJSON["USB"].int = 1
                        vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
//                    }
                }
                self.action()
            }, downBlock: {
                
                
                self.volDown = true
                print("Volume down pressed")
                self.volumeDownImg.image = UIImage(named: "volume_down_green")
                if(self.volUp == true){
                    UserDefaults.standard.set(true, forKey: "volume")
                    print("Volume test passed")
                    self.tearDown()
                    
                    
                        UserDefaults.standard.set(true, forKey: "charger")
                        UserDefaults.standard.set(true, forKey: "earphone")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
                        self.resultJSON["Hardware Buttons"].int = 1
                        self.resultJSON["Earphone"].int = 1
                        self.resultJSON["USB"].int = 1
                        vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    
                }
                self.action()
        })
     
        let handler = volumeButtonHandler
        handler!.start(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tearDown() {
        if let handler = volumeButtonHandler {
            handler.stop()
            volumeButtonHandler = nil
        }
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
