//
//  InternalTestsVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 18/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import Luminous
import INTULocationManager
import SwiftGifOrigin
//import SwiftSpinner
import SwiftyJSON
import CoreBluetooth
import JGProgressHUD

class InternalTestsVC: UIViewController,CBCentralManagerDelegate {
    
    var location = CLLocation()
    var wifiSSID = String()
    var mcc = String()
    var manager:CBCentralManager!
    var mnc = String()
    var networkName = String()
    var connection = true
    var resultJSON = JSON()
    var endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
    
    let hud = JGProgressHUD()
    
    @IBOutlet weak var internalImageView: UIImageView!
    
    @IBAction func beginInternalBtnClicked(_ sender: Any) {
        
        //SwiftSpinner.show(progress: 0.2, title: "Checking_Network".localized)
        //SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
        
        self.hud.textLabel.text = "Checking_Network".localized
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.indicatorView = JGProgressHUDRingIndicatorView()
        self.hud.progress = 0.2
        self.hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            
            self.resultJSON["GSM"].int = 1
            self.resultJSON["Bluetooth"].int = 1
            self.resultJSON["Storage"].int = 1
            self.resultJSON["GPS"].int = 1
            self.resultJSON["Battery"].int = 1
            
            if Luminous.System.Carrier.mobileCountryCode != nil{
                self.mcc = Luminous.System.Carrier.mobileCountryCode!
                self.connection = true
                self.resultJSON["GSM"].int = 1
            }
            if Luminous.System.Carrier.mobileNetworkCode != nil {
                self.mnc = Luminous.System.Carrier.mobileNetworkCode!
                self.connection = true
                self.resultJSON["GSM"].int = 1
            }
            if Luminous.System.Carrier.name != nil {
                self.networkName = Luminous.System.Carrier.name!
                self.connection = true
                self.resultJSON["GSM"].int = 1
            }
            
            switch self.manager.state {
            case .poweredOn:
                print("on")
                self.resultJSON["Bluetooth"] = 1
                break
            case .poweredOff:
                print("off")
                self.resultJSON["Bluetooth"] = 0
                print("Bluetooth is Off.")
                break
            case .resetting:
                print("resetting")
                break
            case .unauthorized:
                print("unauthorized")
                break
            case .unsupported:
                print("unsupported")
                self.resultJSON["Bluetooth"] = -2
                break
            case .unknown:
                print("unknown")
                break
            default:
                self.resultJSON["Bluetooth"] = 1
                break
            }
            
            //SwiftSpinner.show(progress: 0.2, title: "Checking_Bluetooth".localized)
            //SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
            
            self.hud.textLabel.text = "Checking_Bluetooth".localized
            self.hud.progress = 0.4
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                //SwiftSpinner.show(progress: 0.35, title: "Checking_GPS".localized)
                //SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
                
                self.hud.textLabel.text = "Checking_GPS".localized
                self.hud.progress = 0.6
                
                let locationManager = INTULocationManager.sharedInstance()
                locationManager.requestLocation(withDesiredAccuracy: .city,
                                                timeout: 10.0,
                                                delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                                    if (status == INTULocationStatus.success) {
                                                        self.connection = self.connection && true
                                                        // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                        // currentLocation contains the device's current location
                                                        self.location = currentLocation!
                                                        print(currentLocation?.altitude ?? "no location found")
                                                        
                                                        self.resultJSON["GPS"].int = 1
                                                        
                                                    }
                                                    else if (status == INTULocationStatus.timedOut) {
                                                        self.connection = true
                                                        self.resultJSON["GPS"].int = 1
                                                        // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                        // However, currentLocation contains the best location available (if any) as of right now,
                                                        // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                                    }
                                                    else {
                                                        self.resultJSON["GPS"].int = 0
                                                        self.connection = false
                                                        // An error occurred, more info is available by looking at the specific status returned.
                                                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    
                    //SwiftSpinner.show(progress: 0.85, title: "Checking_WiFi".localized)
                    //SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
                    
                    self.hud.textLabel.text = "Checking_WiFi".localized
                    self.hud.progress = 0.8
                    
                    if Luminous.System.Network.isConnectedViaWiFi{
                        self.wifiSSID = Luminous.System.Network.SSID
                        self.connection = self.connection && true
                        self.resultJSON["WIFI"].int = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        //SwiftSpinner.show("Tests_Complete".localized, animated: false)
                        
                        self.hud.textLabel.text = "Tests_Complete".localized
                        self.hud.progress = 1.0
                        
                        if(self.resultJSON["Bluetooth"] == 0){
                            self.connection = false;
                        }
                        UserDefaults.standard.set(self.connection, forKey: "connection")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            
                            //SwiftSpinner.show("Finalising Tests...")
                            self.hud.textLabel.text = "Finalising Tests...".localized
                            
                            var testEmp = false
                            let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
                            if isEmp != nil {
                                testEmp = isEmp
                            }
                            if !testEmp {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Q1VC") as! FirstQViewController
                                //                vc.questionsString = data
                                vc.resultJSON = self.resultJSON
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                                //                            self.modifiersAPI()
                            }else{
                                var appCodeStr = "STON01;SPTS01"
                                if(!UserDefaults.standard.bool(forKey: "camera")){
                                        appCodeStr = "\(appCodeStr);CISS01"
                                    }
                                if(!UserDefaults.standard.bool(forKey: "volume")){
                                        appCodeStr = "\(appCodeStr);CISS02;CISS03"
                                    }
                                if(!UserDefaults.standard.bool(forKey: "connection")){
                                        appCodeStr = "\(appCodeStr);CISS04"
                                    }
                                if(!UserDefaults.standard.bool(forKey: "charger")){
                                        appCodeStr = "\(appCodeStr);CISS05"
                                    }
                                if(!UserDefaults.standard.bool(forKey: "earphone")){
                                        appCodeStr = "\(appCodeStr);CISS11"
                                    }
                                if(!UserDefaults.standard.bool(forKey: "fingerprint")){
                                        appCodeStr = "\(appCodeStr);CISS12"
                                    }
                                appCodeStr = "\(appCodeStr);CLOK01;CPBP01"
                                var failed = false
                                var functional = ""
                                var functional1 = ""
                               
                                if !(UserDefaults.standard.bool(forKey: "deadPixel") && UserDefaults.standard.bool(forKey: "screen")){
                                    functional = "Touch Screen"
                                    functional1 = "Defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "volume")){
                                    functional = "Hardware Buttons"
                                    functional1 = "Defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "connection")){
                                    functional = "WiFi, Bluetooth or GPS"
                                    functional1 = "Defective"
                                    failed = true
                                }
                                
                                if((!UserDefaults.standard.bool(forKey: "proximity"))){
                                    functional = "Proximity Sensor"
                                    functional1 = "defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "rotation")){
                                    functional = "Auto Roatation"
                                    functional1 = "defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "camera")){
                                    functional = "Camera"
                                    functional1 = "defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "fingerprint")){
                                    functional = "Device Biometrics"
                                    functional1 = "defective"
                                    failed = true
                                }
                                if(!UserDefaults.standard.bool(forKey: "mic")){
                                    functional = "Microphone & Speakers"
                                    functional1 = "defective"
                                    failed = true
                                }
                                if failed {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailedVC") as! FailedViewController
                                    vc.modalPresentationStyle = .fullScreen
                                    vc.productName = UserDefaults.standard.string(forKey: "productName")!
                                    vc.productImage = UserDefaults.standard.string(forKey: "productImage")!
                                    vc.functional1 = functional1
                                    vc.functional = functional
                                    self.present(vc, animated: true, completion: nil)
                                }else{
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "upgradeVC") as! UpgradeSuccessViewController
                                    vc.appCodeStr = appCodeStr
                                    vc.resultJOSN = self.resultJSON
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
            UserDefaults.standard.set(self.connection, forKey: "connection")
        }
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("on")
            self.resultJSON["Bluetooth"] = 1
            break
        case .poweredOff:
            print("off")
            self.resultJSON["Bluetooth"] = 0
            print("Bluetooth is Off.")
            break
        case .resetting:
            print("resetting")
            break
        case .unauthorized:
            print("unauthorized")
            break
        case .unsupported:
            print("unsupported")
            self.resultJSON["Bluetooth"] = -2
            break
        case .unknown:
            print("unknown")
            break
        default:
            self.resultJSON["Bluetooth"] = 1
            break
        }
    }
    
   
    
    func modifiersAPI()
    {
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/getProductDetail")!)
        request.httpMethod = "POST"
        let device = Luminous.System.Hardware.Device.current
        let preferences = UserDefaults.standard
        let productId = preferences.string(forKey: "product_id")
        let customerId = preferences.string(forKey: "customer_id")
//        let postString = "productId=\(productId!)&customerId=\(customerId!)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf"
        var postString = ""
        if productId != nil && customerId != nil {
            postString = "productId=\(productId!)&customerId=\(customerId!)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf"
        }else{
            postString = "productId=3138&customerId=4&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf"
        }
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error.debugDescription)")
                //SwiftSpinner.hide()
                self.view.makeToast("internet_prompt".localized, duration: 2.0, position: .bottom)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //SwiftSpinner.hide()
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response.debugDescription)")
            } else{
                do {
                    let json = try JSON(data: data)
                        if json["status"] == "Success" {
                            let productName = json["msg"]["name"].string!
                            
                            let productImage = json["msg"]["image"].string!
                            
                        }
                    }catch{
                }
                
            }
            
            
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        internalImageView.loadGif(name: "internal")
        self.manager          = CBCentralManager()
        self.manager.delegate = self
        // Do any additional setup after loading the view.
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
