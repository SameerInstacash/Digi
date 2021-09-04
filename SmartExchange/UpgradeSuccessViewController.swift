//
//  UpgradeSuccessViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 25/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit
//import SwiftSpinner
import SwiftyJSON
import Luminous
import DKCamera
import DateTimePicker
import JGProgressHUD

class UpgradeSuccessViewController: UIViewController {

    let hud = JGProgressHUD()
    var trdValue = ""
    var trdCurrency = ""
    
    
    @IBOutlet weak var deviceNameText: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var smartExLoader: UIImageView!
    @IBOutlet weak var refValueLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var lblSuccess: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBAction func proceedBtnClicked(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Proceed" {
            
            if (isSynced) {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradeInFormVC") as! TradeInFormVC
                
                vc.formSubmit = { (BankDetails : [String:Any]) in
                    
                    self.lblSuccess.isHidden = false
                    self.proceedBtn.setTitle("Submit", for: .normal)
                }
                
                vc.tradeOrderId = self.orderId
                vc.tradeValue = self.trdValue
                vc.tradeCurrency = self.trdCurrency
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }else {
                DispatchQueue.main.async() {
                    self.view.makeToast("Please wait for the results to sync to the server!".localized, duration: 2.0, position: .bottom)
                }
            }
            
        }else {
            self.goToHome()
        }
            
    }
    
    func goToHome() {
        let imei = UserDefaults.standard.string(forKey: "imei_number")!
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
        vc.IMEINumber = imei
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backToMainBTnClicked(_ sender: Any) {
        self.goToHome()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    var appCodeStr = ""
    var resultJOSN = JSON()
    var deviceName = ""
    var metaDetails = JSON()
    var myArray: Array<String> = []
    var isSynced = false
    var orderId = ""
    var endPoint = "http://exchange.getinstacash.in/store-asia/api/v1/public/"
    
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            
        }
        
        super.viewDidLoad()
        smartExLoader.isHidden = false
        let yourImage: UIImage = UIImage(named: "ic_load")!
        smartExLoader.image = yourImage
        smartExLoader.rotate360Degrees()
        
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        
        //SwiftSpinner.show("Getting Price...")
        callAPI()
        
        DispatchQueue.main.async{
            self.deviceNameText.text = UserDefaults.standard.string(forKey: "productName")
            self.deviceName = UserDefaults.standard.string(forKey: "productName")!
            let img = URL(string: UserDefaults.standard.string(forKey: "productImage")!)
            print("productName: \(self.deviceName), productImage: \(img)")
            self.downloadImage(url: img!)
            
            self.refValueLabel.isHidden = true
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
     func callAPI(){
        
        hud.textLabel.text = "Getting Price...".localized
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
        
            var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/priceCalcNew")!)
            print("endpoint= \(endPoint)")
            request.httpMethod = "POST"
            let store_code = UserDefaults.standard.string(forKey: "store_code")
            let product_id = UserDefaults.standard.string(forKey: "product_id")
            var postString = ""
            let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
            if  isEmp{
                var additionalDetails = JSON()
                let empId = UserDefaults.standard.string(forKey: "empId")
                let empEmail = UserDefaults.standard.string(forKey: "empEmail")
                let empMobile = UserDefaults.standard.string(forKey: "empMobile")
                additionalDetails["employeeId"].string = empId
                additionalDetails["employeeEmailAddress"].string = empEmail
                additionalDetails["employeeMobileNumber"].string = empMobile
                
                
                postString = "isAppCode=1&str=\(appCodeStr)&storeCode=\(store_code!)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&productId=\(product_id!)&additionalInformation=\(additionalDetails)"
            }else{
                
            }
            
            print("postString= \(postString)")
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async() {
                    self.hud.dismiss()
                }
                
                guard let dataThis = data, error == nil else {
                    //SwiftSpinner.hide()
                    // check for fundamental networking error
                    print("error=\(error.debugDescription)")
                    self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           //
                    //SwiftSpinner.hide()
    //                check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response.debugDescription)")
                } else{
                    print("response = \(response)")
                    
                    do {
                        let json = try JSON(data: dataThis)
                        if  let offerpriceString = json["msg"].string {
                            let jsonString = UserDefaults.standard.string(forKey: "currencyJson")!
                            self.saveResult(price: offerpriceString)
                            
                            
                            self.trdValue = String(offerpriceString)
                            self.trdCurrency = json["currency"].string ?? ""
                            
                        }else{
                            self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                            print(" xBroken")
                        }
                        
                    }catch {
                        DispatchQueue.main.async() {
                            self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            task.resume()
        }
        
        
        func saveResult(price: String){
            
            self.hud.textLabel.text = ""
            self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
            self.hud.show(in: self.view)
            
            var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/savingResult")!)
            request.httpMethod = "POST"
            var netType = "Mobile"
            if Luminous.System.Network.isConnectedViaWiFi {
                netType = "Wifi"
            }
            metaDetails["currentCountry"].string = Luminous.System.Locale.currentCountry
            metaDetails["Internet  Type"].string = netType
            metaDetails["Internet  SSID"].string = Luminous.System.Network.SSID
            metaDetails["Internet Availability"].bool = Luminous.System.Network.isInternetAvailable
            metaDetails["Carrier Name"].string = Luminous.System.Carrier.name
            metaDetails["Carrier MCC"].string = Luminous.System.Carrier.mobileCountryCode
            metaDetails["Carrier MNC"].string = Luminous.System.Carrier.mobileNetworkCode
            metaDetails["Carrier Allows VOIP"].bool = Luminous.System.Carrier.allowsVOIP
            metaDetails["GPS Location"].string = Luminous.System.Locale.currentCountry
            metaDetails["Battery Level"].float = Luminous.System.Battery.level
            metaDetails["Battery State"].string = "\(Luminous.System.Battery.state)"
            metaDetails["currentCountry"].string = Luminous.System.Locale.currentCountry
            
            let customerId = UserDefaults.standard.string(forKey: "customer_id")
            let resultCode = ""
            let imei = UserDefaults.standard.string(forKey: "imei_number")
            let product_id = UserDefaults.standard.string(forKey: "product_id")
            
            let postString = "customerId=\(customerId!)&resultCode=\(resultCode)&resultJson=\(self.resultJOSN)&price=\(price)&deviceName=\(self.deviceName)&conditionString=\(self.appCodeStr)&metaDetails=\(metaDetails)&IMEINumber=\(imei!)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&productId=\(product_id!)"
            print("\(postString)")
            
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                guard let dataThis = data, error == nil else {
                    //SwiftSpinner.hide()
                    // check for fundamental networking error
                    print("error=\(error.debugDescription)")
                    self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //
                    //SwiftSpinner.hide()
                    //                check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response.debugDescription)")
                } else{
                    do{
                        let json = try JSON(data: dataThis)
                        let msg = json["msg"]
                        self.orderId = msg["orderId"].string ?? ""
                        print("orderId", self.orderId)
                        self.isSynced = true
                        
                        DispatchQueue.main.async{
                            self.smartExLoader.isHidden = true
                            self.refValueLabel.isHidden = false
                            self.refValueLabel.text = "Reference No: \(self.orderId)"
                            self.view.makeToast("Details Synced to the server. Please contact Store Executive for further information", duration: 1.0, position: .bottom)
                            }
                    }catch {
                        DispatchQueue.main.async() {
                            self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                            
                        }
                        
                    }
                }
                
                
            }
            task.resume()
        }
        
        
        
        func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, response, error)
                }.resume()
        }
        
        func downloadImage(url: URL) {
            print("Download Started")
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.deviceImage.image = UIImage(data: data)
                }
            }
        }

}
