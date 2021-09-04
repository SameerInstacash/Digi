//
//  PriceViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 24/04/18.
//  Copyright © 2018 ZeroWaste. All rights reserved.
//

import UIKit
//import SwiftSpinner
import SwiftyJSON
import Luminous
import DKCamera
import DateTimePicker
import JGProgressHUD

class PriceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let hud = JGProgressHUD()
    var trdValue = ""
    var trdCurrency = ""
        
    @IBOutlet weak var scheduleVisitBtn: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var refValueLabel: UILabel!
    @IBOutlet weak var visitDigiInfo: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var lblProceedDetail: UILabel!
    
    @IBOutlet weak var lblBankDetailInfo: UILabel!
    @IBOutlet weak var offeredPriceInfo: UILabel!
    @IBOutlet weak var diagnosisChargesInfo: UILabel!
    @IBOutlet weak var payableBtnInfo: UILabel!
    @IBOutlet weak var lblBankInfo: UILabel!
    
    @IBOutlet weak var lblBankDetail: UILabel!
    @IBOutlet weak var offeredPrice: UILabel!
    @IBOutlet weak var diagnosisCharges: UILabel!
    @IBOutlet weak var payableAmount: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var exitAppBtn: UIButton!
    
    @IBOutlet weak var loaderImage: UIImageView!
    
    @IBAction func proceedBtnClick(_ sender: UIButton) {
        
        if (isSynced) {
            
            //if sender.titleLabel?.text == "Proceed" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradeInFormVC") as! TradeInFormVC
            
            vc.formSubmit = { (BankDetails : [String:Any]) in
                
                self.lblBankDetailInfo.isHidden = false
                self.lblBankDetail.isHidden = false
                self.lblBankInfo.isHidden = false
                self.lblBank.isHidden = false
                
                self.payableBtnInfo.isHidden = true
                self.payableAmount.isHidden = true
                
                
                self.lblBankDetailInfo.text = "Bank Account Details"
                self.lblBankDetail.text = "  "
                
                self.offeredPriceInfo.text = "Bank Account Number"
                self.diagnosisChargesInfo.text = "Bank Holders Name"
                self.lblBankInfo.text = "Bank Name"
                
                if let number = BankDetails["Bank Account Number"] as? String {
                    let lastFourChar = number.suffix(4)
                    
                    self.offeredPrice.text = "********" + String(lastFourChar)
                }else {
                    self.offeredPriceInfo.isHidden = true
                    self.offeredPrice.isHidden = true
                }
                
                if let name = BankDetails["Bank Holders Name"] as? String {
                    self.diagnosisCharges.text = name
                }else {
                    self.diagnosisChargesInfo.isHidden = true
                    self.diagnosisCharges.isHidden = true
                }
                
                if let bankName = BankDetails["Bank Name"] as? String {
                    self.lblBank.text = bankName
                }else {
                    self.lblBankInfo.isHidden = true
                    self.lblBank.isHidden = true
                }
                
                
                self.lblProceedDetail.text = "Thank you for your interest \n Visit a Digi store today!"
                self.proceedBtn.setTitle("Previous", for: .normal)
                self.exitAppBtn.setTitle("Submit", for: .normal)
                
            }
            
            
            vc.tradeOrderId = self.orderId
            vc.tradeValue = self.trdValue
            vc.tradeCurrency = self.trdCurrency
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            //}else {
            //self.goToHome()
            //}
            
        }else{
            DispatchQueue.main.async() {
                self.view.makeToast("Please wait for the results to sync to the server!".localized, duration: 2.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func backtoHome(_ sender: Any) {
        self.goToHome()
    }
    
    func goToHome() {
        let imei = UserDefaults.standard.string(forKey: "imei_number")!
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
        vc.IMEINumber = imei
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    //    @IBAction func scheduleVisitBtnClicked(_ sender: Any) {
//        let min = Date().addingTimeInterval(0)
//        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
//        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
//        picker.completionHandler = { date in
//            let formatter = DateFormatter()
//            formatter.dateFormat = "YYYY/MM/dd hh:mm:ss"
//
//            let dt = formatter.string(from: date)
//            print("date: \(dt)")
//            DispatchQueue.main.async{
//                var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/scheduleVisit")!)
//                request.httpMethod = "POST"
//                let postString = "storeToken=&orderId=\(self.orderId)&type=set&scheduleDateTime=\(dt)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf"
//
//                request.httpBody = postString.data(using: .utf8)
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    guard let dataThis = data, error == nil else {
//                        SwiftSpinner.hide()
//                        // check for fundamental networking error
//                        print("error=\(error.debugDescription)")
//                        self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
//                        return
//                    }
//
//                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           //
//                        SwiftSpinner.hide()
//                        //                check for http errors
//                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                        print("response = \(response.debugDescription)")
//                    } else{
//                        DispatchQueue.main.async{
//                            self.view.makeToast("Visit Scheduled successfully!", duration: 1.0, position: .bottom)
//                        }
//
//                        print("response = \(response)")
//
//                    }
//
//                }
//
//
//                task.resume()
//
//                picker.removeFromSuperview()
//            }
//        }
//        picker.dismissHandler = {
//            DispatchQueue.main.async{
//                self.view.makeToast("Schedule Visit Cancelled", duration: 1.0, position: .bottom)
//                picker.removeFromSuperview()
//            }
//
//        }
//
//        let screenSize: CGRect = UIScreen.main.bounds
//
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//
//        picker.frame = CGRect(x: 0, y: (screenHeight-picker.frame.size.height), width: picker.frame.size.width, height: picker.frame.size.height)
//        self.view.addSubview(picker)
//    }
//
    
    
    
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
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            
        }
        
        self.setStatusBarColor()
        
        super.viewDidLoad()
        loaderImage.isHidden = false
        let yourImage: UIImage = UIImage(named: "ic_load")!
        loaderImage.image = yourImage
        loaderImage.rotate360Degrees()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let heightForTable = (self.payableBtnInfo.frame.maxY + 20)
        
        
        //self.myTableView.register(UINib(nibName: "PriceTblCell", bundle: nil), forCellReuseIdentifier: "PriceTblCell")
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        
        
        
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        
        //SwiftSpinner.show("Getting Price...")
        
        callAPI()
        
        DispatchQueue.main.async{
            self.productName.text = UserDefaults.standard.string(forKey: "productName")
            self.deviceName = UserDefaults.standard.string(forKey: "productName")!
            let img = URL(string: UserDefaults.standard.string(forKey: "productImage")!)
            print("productName: \(self.deviceName), productImage: \(img)")
            self.downloadImage(url: img!)
            
            self.refValueLabel.isHidden = true
        }
        
    }

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
            postString = "isAppCode=1&str=\(appCodeStr)&storeCode=\(store_code!)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&productId=\(product_id!)"
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
                        var multiplier:Float = 1.0
                        var symbol:String = "₹"
                        var curCode:String = "INR"
                        var symbolNew = json["currency"].string
                        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                            print("currency JSON")
                            let currencyJson = try JSON(data: dataFromString)
                            multiplier = Float(currencyJson["Conversion Rate"].string!)!
                            print("multiplier: \(multiplier)")
                            symbol = currencyJson["Symbol"].string!
                            curCode = currencyJson["Code"].string!
                        }else{
                            print("No values")
                        }
                        
                        var diagnosisChargeString = Float(json["diagnosisCharges"].intValue)
                        
                        if symbol != symbolNew {
                            diagnosisChargeString = diagnosisChargeString * multiplier
                        }
                        print("diagnosis charge: \(Float(json["diagnosisCharges"].intValue)), In IDR: \(diagnosisChargeString) ")
                        var offer = Float(offerpriceString) ?? 0.00
                        if curCode != symbolNew{
                            offer = offer * multiplier
                        }
                        print("offerpriceString: \(Float(offerpriceString)), In IDR: \(offer) ")
                        let payable = offer - diagnosisChargeString
                        print("payable: \(offer - diagnosisChargeString) ")
                        self.saveResult(price: offerpriceString)
                        
                        DispatchQueue.main.async() {
                            self.payableAmount.text = "\(symbol)\(Int(payable))"
                            self.diagnosisCharges.text = "\(symbol)\(Int(diagnosisChargeString))"
                            self.offeredPrice.text = "\(symbol)\(Int(offer))"
                            //SwiftSpinner.hide()
                        }
                        
                        self.trdValue = String(payable)
                        self.trdCurrency = symbol
                        
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
                self.loaderImage.isHidden = true
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
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response.debugDescription)")
            } else{
                do{
                    let json = try JSON(data: dataThis)
                    let msg = json["msg"]
                    self.orderId = msg["orderId"].string ?? ""
                    print("orderId", self.orderId)
                    self.isSynced = true
                    
                    DispatchQueue.main.async {
                        self.loaderImage.isHidden = true
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
                self.productImage.image = UIImage(data: data)
            }
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
    
    
//    @IBAction func uploadIdBtnClicked(_ sender: Any) {
//        let camera = DKCamera()
//        camera.didCancel = {
//            self.dismiss(animated: true, completion: nil)
//        }
//        print("upload Id Clicked")
//        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
//            print("didFinishCapturingImage")
//            self.dismiss(animated: true, completion: nil)
//            var newImage = self.resizeImage(image: image!, newWidth: 800)
//            let imageData:NSData = UIImagePNGRepresentation(newImage) as! NSData
//            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//
//            var request = URLRequest(url: URL(string: "\(self.endPoint)/idProof")!)
//            request.httpMethod = "POST"
//            let customerId = UserDefaults.standard.string(forKey: "customer_id")
//            let postString = "customerId=\(customerId)&orderId=\(self.orderId)&photo=\(strBase64)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf"
//
//            request.httpBody = postString.data(using: .utf8)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let dataThis = data, error == nil else {
//                    SwiftSpinner.hide()
//                    // check for fundamental networking error
//                    print("error=\(error.debugDescription)")
//                    self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
//                    return
//                }
//
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           //
//                    SwiftSpinner.hide()
//                    //                check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(response.debugDescription)")
//                } else{
//                    DispatchQueue.main.async{
//                        self.view.makeToast("Photo Id uploaded successfully!", duration: 1.0, position: .bottom)
//                    }
//
//                    print("response = \(response)")
//
//                }
//
//            }
//
//
//
//            task.resume()
//        }
//        self.present(camera, animated: true, completion: nil)
//    }
//
    @IBOutlet weak var myTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
    
}
