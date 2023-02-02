//
//  ViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 15/02/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import Luminous
import QRCodeReader
import SwiftyJSON
import Toast_Swift
//import Sparrow
import JGProgressHUD
import Firebase

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
 
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertToDateFormate(current: String, convertTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = current
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = convertTo
        return  dateFormatter.string(from: date)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public extension UIDevice {
    
    var moName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        //switch identifier {
        switch identifier.replacingOccurrences(of: " ", with: "") {
        
        case "iPod5,1":                                 return "iPod touch (5th generation)"
        case "iPod7,1":                                 return "iPod touch (6th generation)"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
            
        case "iPhone14,4":                              return "iPhone 13 Mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
            
        case "iPhone14,6":                              return "iPhone SE 3rd Gen"
            
        case "iPhone14,7":                              return "iPhone 14"
        case "iPhone14,8":                              return "iPhone 14 Plus"
        case "iPhone15,2":                              return "iPhone 14 Pro"
        case "iPhone15,3":                              return "iPhone 14 Pro Max"
            
            
        //iPad
        case "iPad1,1", "iPad1,2":                      return "iPad (1st generation)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad (2nd generation)"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
        case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
        case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
        case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            
        //iPad Air
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air (1st generation)"
        case "iPad5,3", "iPad5,4":                      return "iPad Air (2nd generation)"
        case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
        //case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            
        //iPad Mini
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini (1st generation)"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini (2nd generation)"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini (3rd generation)"
        case "iPad5,1", "iPad5,2":                      return "iPad mini (4th generation)"
        case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            
        //iPad Pro
        case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            
        case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            
            //New iPads add on 6/10/22
            case "iPad12,1":                    return "iPad 9th Gen (WiFi)"
            case "iPad12,2":                    return "iPad 9th Gen (WiFi+Cellular)"
            case "iPad14,1":                    return "iPad mini 6th Gen (WiFi)"
            case "iPad14,2":                    return "iPad mini 6th Gen (WiFi+Cellular)"
            case "iPad13,1":                    return "iPad Air 4th Gen (WiFi)"
            case "iPad13,2":                    return "iPad Air 4th Gen (WiFi+Cellular)"
            case "iPad13,4":                    return "iPad Pro 11 inch 5th Gen"
            case "iPad13,5":                    return "iPad Pro 11 inch 5th Gen"
            case "iPad13,6":                    return "iPad Pro 11 inch 5th Gen"
            case "iPad13,7":                    return "iPad Pro 11 inch 5th Gen"
            case "iPad13,8":                    return "iPad Pro 12.9 inch 5th Gen"
            case "iPad13,9":                    return "iPad Pro 12.9 inch 5th Gen"
            case "iPad13,10":                    return "iPad Pro 12.9 inch 5th Gen"
            case "iPad13,11":                    return "iPad Pro 12.9 inch 5th Gen"
            case "iPad13,16":                    return "iPad Air 5th Gen (WiFi)"
            case "iPad13,17":                    return "iPad Air 5th Gen (WiFi+Cellular)"
            
        
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "AudioAccessory5,1":                       return "HomePod mini"
        case "i386", "x86_64":                          return "iPad Pro (11-inch) (2nd generation)"
        default:                                        return identifier
        
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}



class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    var IMEINumber = String()
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var imeiLabel: UILabel!
    @IBOutlet weak var findStoreBtn: UIButton!
    @IBOutlet weak var scanQRBtn: UIButton!
    //@IBOutlet weak var smartExLoadingImage: UIImageView!
//    @IBOutlet weak var retryBtn: UIButton!
    
    let reachability: Reachability? = Reachability()
    let hud = JGProgressHUD()
    var arrStoreUrlData = [StoreUrlData]()
    var dictDigiStoreUrlData : DigiStoreUrlData?
    
    
    @IBOutlet weak var storeTokenEdit: UITextField!
    @IBOutlet weak var submitStoreBtn: UIButton!
    
    var endPoint = "http://exchange.getinstacash.in/store-asia/api/v1/public/"
    var storeToken: String = ""
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        self.fetchStoreDataFromFirebase()
        
        self.descriptionLbl.text = "Please refer to Digi frontliner on the “Store Token” or “QR code” to begin \n OR \n Click on “Previous Quotation” to view previous results"
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let imei = UserDefaults.standard.string(forKey: "imei_number")
        scanQRBtn.layer.cornerRadius = 6
        
        
        let uuid = UUID().uuidString
        //smartExLoadingImage.isHidden = true
        imeiLabel.text = IMEINumber

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if !SPRequestPermission.isAllowPermissions([.camera,.locationWhenInUse,.microphone,.photoLibrary]){
        SPRequestPermission.dialog.interactive.present(on: self, with: [.camera,.microphone,.photoLibrary,.locationWhenInUse], dataSource: DataSource())
        }
        */
    }
    
    func fetchStoreDataFromFirebase() {
                
        if reachability?.connection.description != "No Connection" {
            
            self.hud.textLabel.text = ""
            self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
            self.hud.show(in: self.view)
        
            StoreUrlData.fetchStoreUrlsFromFireBase(isInterNet: true, getController: self) { (storeData) in
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                if storeData.count > 0 {
                    
                    self.arrStoreUrlData = storeData
                    
                    DigiStoreUrlData.fetchDigiStoreUrlsFromFireBase(isInterNet: true, getController: self) { digiStoreData in
                        
                        self.dictDigiStoreUrlData = digiStoreData
                        
                    }
                    
                }else {
                    
                    //MARK: 31/1/23 Ajay told to handle this
                    
                    self.arrStoreUrlData = []
                    print("No Data Found")
                    
                    
                    /*
                    DispatchQueue.main.async() {
                        self.view.makeToast("No Data Found".localized, duration: 2.0, position: .bottom)
                    }
                    */
                    
                }
                
            }
            
        }else {
            DispatchQueue.main.async() {
                self.view.makeToast("Please Check Internet connection.".localized, duration: 2.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func submitStoreToken(_ sender: Any) {
        
        self.storeToken = String(storeTokenEdit.text ?? "0")
        
        guard self.storeToken != "" else {
            
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Store Token.".localized, duration: 2.0, position: .bottom)
            }
            
            return
        }
        
        if self.storeToken.count >= 4 {
            
            let enteredToken = self.storeToken.prefix(4)
            
            if self.arrStoreUrlData.count > 0 {
                
                for tokens in self.arrStoreUrlData {
                    if tokens.strPrefixKey == enteredToken {
                        self.endPoint = tokens.strUrl
                        
                        let preferences = UserDefaults.standard
                        preferences.setValue(tokens.strTnc, forKey: "tncendpoint")
                        preferences.setValue(tokens.strType, forKey: "storeType")
                        preferences.setValue(tokens.strIsTradeOnline, forKey: "tradeOnline")
                        
                        self.verifyUserSmartCode()
                        
                        break
                    }
                }
                
            }else {
                
                //for tokens in self.arrStoreUrlData {
                    //if tokens.strPrefixKey == enteredToken {
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        
                        let preferences = UserDefaults.standard
                        preferences.setValue("https://exchange.getinstacash.com.my/stores-asia/tnc.php", forKey: "tncendpoint")
                        preferences.setValue(0, forKey: "storeType")
                        preferences.setValue(0, forKey: "tradeOnline")
                        
                        self.verifyUserSmartCode()
                        
                        //break
                    //}
                //}
                
            }
            
            
            
        }else {
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Valid Store Token".localized, duration: 2.0, position: .bottom)
            }
        }
        
        
    }
    
    
    var responseData = " "
   
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
    $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
    $0.showTorchButton = true
    
    $0.reader.stopScanningWhenCodeIsFound = false
    }
    
    return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
    
            switch error.code {
                case -11852:
                    alert = UIAlertController(title: "Error".localized, message: "This app is not authorized to use Back Camera.".localized, preferredStyle: .alert)
    
                    alert.addAction(UIAlertAction(title: "Setting".localized, style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.openURL(settingsURL)
                            }
                        }
                    }))
    
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                default:
                    alert = UIAlertController(title: "Error".localized, message: "Reader not supported by the current device".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
            }
    
            present(alert, animated: true, completion: nil)
    
            return false
        }
    }
    
    
    @IBAction func scanQRPressed(_ sender: Any) {
        guard checkScanPermissions() else { return }
        
            readerVC.modalPresentationStyle = .formSheet
            readerVC.delegate               = self

            readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    
                    print("result is : \(result.value)")
                    self.storeToken = String(result.value)
                    print("code is : \(self.storeToken.prefix(4))")
                    
                    
                    
                    if self.storeToken.count >= 4 {
                        
                        let enteredToken = self.storeToken.prefix(4)
                        
                        if self.arrStoreUrlData.count > 0 {
                            
                            for tokens in self.arrStoreUrlData {
                                if tokens.strPrefixKey == enteredToken {
                                    self.endPoint = tokens.strUrl
                                    
                                    let preferences = UserDefaults.standard
                                    preferences.setValue(tokens.strTnc, forKey: "tncendpoint")
                                    preferences.setValue(tokens.strType, forKey: "storeType")
                                    preferences.setValue(tokens.strIsTradeOnline, forKey: "tradeOnline")
                                    
                                    self.verifyUserSmartCode()
                                    
                                    break
                                }
                            }
                            
                        }else {
                            
                            //for tokens in self.arrStoreUrlData {
                                //if tokens.strPrefixKey == enteredToken {
                            
                            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                            
                            let preferences = UserDefaults.standard
                            preferences.setValue("https://exchange.getinstacash.com.my/stores-asia/tnc.php", forKey: "tncendpoint")
                            preferences.setValue(0, forKey: "storeType")
                            preferences.setValue(0, forKey: "tradeOnline")
                            
                            self.verifyUserSmartCode()
                                    
                                    //break
                                //}
                            //}
                            
                        }
                        
                        
                        
                    }else {
                        DispatchQueue.main.async() {
                            self.view.makeToast("Store Token Not Valid".localized, duration: 2.0, position: .bottom)
                        }
                    }
                    
                    
                    
                }
            }

            present(readerVC, animated: true, completion: nil)
    }
    
    
//    @IBAction func retryBtnPressed(_ sender: Any?) {
//        verifyUserSmartCode()
//    }
    
    func verifyUserSmartCode() {
        
        
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
                
        let device = UIDevice.current.moName
//        retryBtn.isHidden = true
        //smartExLoadingImage.isHidden = false
        //smartExLoadingImage.rotate360Degrees()
        var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/startSession")!)
        let preferences = UserDefaults.standard
        preferences.set(endPoint, forKey: "endpoint")
        request.httpMethod = "POST"
        //        let mName = UIDevice.current.modelName
        let modelCapacity = getTotalSize()
        //        let model =  "\(mName)"
        let IMEI = imeiLabel.text
        let ram =  ProcessInfo.processInfo.physicalMemory
        let postString = "IMEINumber=\(IMEI!)&device=\(device)&memory=\(modelCapacity)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=\(ram)&storeToken=\(storeToken)"
        
//        let postString = "IMEINumber=\(IMEI!)&device=iPhone XR&memory=64&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=2919613952&storeToken=\(storeToken)"
//                let postString = "IMEINumber=\(IMEI!)&device=a0001&memory=64&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=3&storeToken=6016"
        
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async() {
                self.hud.dismiss()
            }
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error.debugDescription)")
                //self.smartExLoadingImage.layer.removeAllAnimations()
                //self.smartExLoadingImage.isHidden = true
//                self.retryBtn.isHidden = false
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response?.description)")
                //self.smartExLoadingImage.layer.removeAllAnimations()
                //self.smartExLoadingImage.isHidden = true
//                self.retryBtn.isHidden = false
            } else{
                do {
                    let json = try JSON(data: data)
                    if json["status"] == "Success" {
                        print("\(json)")
                        let responseString = String(data: data, encoding: .utf8)
                        self.responseData = responseString!
                        let preferences = UserDefaults.standard
                        var productId = "0"
                        let productData = json["productData"]
                        if productData["id"].string ?? "" != "" {
                            productId = productData["id"].string ?? ""
                            let productName = productData["name"]
                            let productImage = productData["image"]
                            preferences.set(productId, forKey: "product_id")
                            preferences.set("\(productName)", forKey: "productName")
                            preferences.set("\(productImage)", forKey: "productImage")
                            print("productName: \(productName), productImage: \(productImage)")
                            preferences.set(json["customerId"].string!, forKey: "customer_id")
                            preferences.set("6016", forKey: "store_code")
                            let serverData = json["serverData"]
                            print("\n\n\(serverData["currencyJson"])")
                            let jsonEncoder = JSONEncoder()
                            let currencyJSON = serverData["currencyJson"]
                            let jsonData = try jsonEncoder.encode(currencyJSON)
                            let jsonString = String(data: jsonData, encoding: .utf8)
                            preferences.set(jsonString, forKey: "currencyJson")
                           
                            DispatchQueue.main.async() {
                                //if self.storeToken == "6039" {
                                if self.storeToken.contains("6039") {
                                    
                                    let tradeUp = self.dictDigiStoreUrlData?.dictTradeUp
                                    UserDefaults.standard.setValue(tradeUp?["accept_tnc"] ?? "", forKey: "digiAcceptTnc")
                                    UserDefaults.standard.setValue(tradeUp?["tnc"] ?? "", forKey: "digiTnc")
                                    
                                    
                                    UserDefaults.standard.set(true, forKey: "isEmp")
                                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "TNCVC") as! TnCViewController
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserVC") as! UserDetailsViewController
                                    vc.productName = productName.string ?? ""
                                    vc.productImage = productImage.string ?? ""
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }else {
                                    //if self.storeToken == "6016" {
                                    if self.storeToken.contains("6016") {
                                        
                                        let tradeIn = self.dictDigiStoreUrlData?.dictTradeIn
                                        UserDefaults.standard.setValue(tradeIn?["accept_tnc"] ?? "", forKey: "digiAcceptTnc")
                                        UserDefaults.standard.setValue(tradeIn?["tnc"] ?? "", forKey: "digiTnc")
                                  
                                        
                                        UserDefaults.standard.set(false, forKey: "isEmp")
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SmartExMainVC") as! SmartExMainVC
                                        vc.productName = productName.string ?? ""
                                        vc.productImage = productImage.string ?? ""
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                        
                                    }else{
                                        DispatchQueue.main.async() {
                                            self.view.makeToast("Not a valid Token for Digi Stores!", duration: 2.0, position: .bottom)
                                        }
                                    }
                                }
                                
                                //self.smartExLoadingImage.layer.removeAllAnimations()
                                //self.smartExLoadingImage.isHidden = true
                            }
                            
                        }else{
                            DispatchQueue.main.async() {
                                self.view.makeToast("Device not found!", duration: 2.0, position: .bottom)
                            }
                        }
                    }else{
                        DispatchQueue.main.async() {
                            //self.smartExLoadingImage.layer.removeAllAnimations()
                            //self.smartExLoadingImage.isHidden = true
                            self.view.makeToast("Please make sure you've entered the details in the POS.", duration: 2.0, position: .bottom)
                        }
                    }
                }catch{
                    DispatchQueue.main.async() {
                        //self.smartExLoadingImage.layer.removeAllAnimations()
                        //self.smartExLoadingImage.isHidden = true
//                        self.retryBtn.isHidden = false
                        self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                    }
                }
            }
        }
        task.resume()
    }
  
    func getTotalSize() -> Int64{
        var space: Int64 = 0
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            space = ((systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value)!
            space = space/1000000000
            if space<8{
                space = 8
            } else if space<16{
                space = 16
            } else if space<32{
                space = 32
            } else if space<64{
                space = 64
            } else if space<128{
                space = 128
            } else if space<256{
                space = 256
            } else if space<512{
                space = 512
            }
        } catch {
            space = 0
        }
        return space
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
        }
    }
    
   
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.storeImage.image = UIImage(data: data)
            }
        }
    }


   
}

/*
class DataSource: SPRequestPermissionDialogInteractiveDataSource {
    
    //override title in dialog view
    override func headerTitle() -> String {
        return "Digi Trade-up"
    }
    
    override func headerSubtitle() -> String {
        return "header_title".localized
    }
 
}
*/
