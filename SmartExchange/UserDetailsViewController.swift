//
//  UserDetailsViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 28/07/19.
//  Copyright © 2019 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON
import BEMCheckBox
import JGProgressHUD
import WebKit

class UserDetailsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var baseWebView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTncAccept: UILabel!
    @IBOutlet weak var webViewHeightConstraint : NSLayoutConstraint!
    var webView: WKWebView!
    var loadableUrlStr: String?
    let hud = JGProgressHUD()
    
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    var email = ""
    var mob = ""
    var appCodeStr = ""
    var resultJOSN = JSON()
    
    var productName = ""
    var productImage = ""
    
    @IBOutlet weak var loaderImg: UIImageView!
//    @IBOutlet weak var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.lblTitle.text = "Digi Trade-Up"
        }else {
            // Trade In
            self.lblTitle.text = "Digi Trade-In"
        }
        
        super.viewDidLoad()
        //loaderImg.isHidden = true
                
        DispatchQueue.main.async {
            
            if let tnc = UserDefaults.standard.value(forKey: "digiAcceptTnc") as? String {
                self.lblTncAccept.text = tnc
            }
            
            if let tncHtml = UserDefaults.standard.value(forKey: "digiTnc") as? String {
                self.LoadWebView(tncHtml)
            }
            
        }
        
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if (checkBox.on){
            
            let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
            if isEmp {
                self.tradeUpCall()
            }else {
                self.tradeInCall()
            }
        }else{
            self.view.makeToast("Please Accept terms to continue", duration: 2.0, position: .bottom)
        }
    }
    
    //MARK: Custom Methods
    func LoadWebView(_ strHtml : String) {
        webView = self.addWKWebView(viewForWeb: self.baseWebView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //let myURL = URL(string: loadableUrlStr ?? "")
        //let myRequest = URLRequest(url: myURL!)
        //webView.load(myRequest)
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        webView.loadHTMLString(headerString + strHtml, baseURL: nil)
        //webView.loadHTMLString(strHtml, baseURL: nil)
        
        //add observer to get estimated progress value
        //self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame.size = viewForWeb.frame.size
        viewForWeb.addSubview(webView)
        return webView
    }
    
    //MARK: WKWebView delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    //self.containerHeight.constant = height as! CGFloat
                    self.webViewHeightConstraint.constant = height as! CGFloat
                    
                    print()
                })
            }
            
        })
    }
    
    func tradeUpCall(){
        DispatchQueue.main.async() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckVC") as! CheckConditionViewController
            vc.productName = self.productName
            vc.productImage = self.productImage
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tradeInCall(){
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
        
        
        var functional = "Functional Issue: "
        var start = 0
        
        
        let l = UserDefaults.standard.string(forKey: "lcd")
        let lc = "LCD/Touch Screen "
        let lcd = "\(lc): \(l!)"
        let u = UserDefaults.standard.string(forKey: "lock")
        let pl = "Phone Locks"
        let db = "Device Body"
        let lock = "\(pl): \(u!)"
        let b = UserDefaults.standard.string(forKey: "back")
        print(b)
        let back = "\(db): \(b!)"
        
        var myArray: Array = [lcd, lock, back ]
        if(!UserDefaults.standard.bool(forKey: "volume")){
            functional = "Hardware Buttons: Defective"
            myArray.append(functional)
        }
        if(!UserDefaults.standard.bool(forKey: "connection")){
            functional = "WiFi, Bluetooth or GPS: Defective"
            myArray.append(functional)
        }
        
        if((!UserDefaults.standard.bool(forKey: "proximity"))){
            functional = "Proximity Sensor: defective"
            myArray.append(functional)
        }
        if(!UserDefaults.standard.bool(forKey: "rotation")){
            functional = "Auto Roatation: defective"
            myArray.append(functional)
        }
        if(!UserDefaults.standard.bool(forKey: "camera")){
            functional = "Camera: defective"
            myArray.append(functional)
        }
        if(!UserDefaults.standard.bool(forKey: "fingerprint")){
            functional = "Device Biometrics: defective"
            myArray.append(functional)
        }
        if(!UserDefaults.standard.bool(forKey: "mic")){
            functional = "Microphone: defective"
            myArray.append(functional)
            functional = "Speakers: defective"
            myArray.append(functional)
        }
        var request = URLRequest(url: URL(string: "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/updateCustomer")!)
        request.httpMethod = "POST"
        let customerId = UserDefaults.standard.string(forKey: "customer_id")
        let postString = "customerId=\(customerId)&name=&mobile=&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&email="
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async() {
                self.hud.dismiss()
            }
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                DispatchQueue.main.async() {
                    print("error=\(error.debugDescription)")
                    //self.loaderImg.layer.removeAllAnimations()
                    //self.loaderImg.isHidden = true
                    //self.retryBtn.isHidden = false
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response?.description)")
                //                self.retryBtn.isHidden = false
            } else{
                DispatchQueue.main.async() {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PriceVC") as! PriceViewController
                    vc.appCodeStr = self.appCodeStr
                    vc.resultJOSN = self.resultJOSN
                    vc.myArray = myArray
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
