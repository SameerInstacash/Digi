//
//  TradeInFormVC.swift
//  SmartExchange
//
//  Created by Sameer Khan on 19/02/21.
//  Copyright © 2021 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON
import Luminous
import DropDown
import Alamofire
import AlamofireImage
//import SwiftSpinner
import JGProgressHUD

class TradeInFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var formSubmit : ((_ formDict : [String:Any]) -> Void)?
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    
    let hud = JGProgressHUD()
    
    var tradeOrderId = ""
    var tradeValue = ""
    var tradeCurrency = ""
    
    var endPoint = "http://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
    
    var drop = UIDropDown()
    var arrDrop = [String]()
    
    var responseDictIN = [String : Any]()
    var responseDict = [String : Any]()
    var arrDictKeys = [Any]()
    var arrDictKeys1 = [String]()
    var arrDictValues = [[Any]]()
    
    var isHtml = true
    var setInfo = [String:String]()
    
    var bankDetails = [String:Any]()
    var bankDict = [String:Any]()
    var arrBankKeysMendatory = [String]()
    //var arrBankKeysOptional = [String]()
    var placeHold : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
        }
        
        self.setStatusBarColor()
        
        //self.lblScreenTitle.text = "Smart Exchange".localized
        //self.lblPleaseEnter.text = "Please Enter your details below".localized
        self.lblPleaseEnter.text =  "Transfer Details"
        self.btnProceed.setTitle("Proceed".localized, for: .normal)

        self.hideKeyboardWhenTappedAround()
        
        self.getMaxisForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.formTableView.tableFooterView = UIView()
    }
    
    //MARK:- webservice Get maxis form
    
    func getMaxisForm() {
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
        
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        var request = URLRequest(url: URL(string: "\(self.endPoint)/getMaxisForm")!)
        print("endpoint= \(endPoint)")
        request.httpMethod = "POST"
        
        let postString = "userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&cartId=\(self.tradeOrderId)"
        print("postString= \(postString)")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                self.hud.dismiss()
            }
            
            guard let dataThis = data, error == nil else {
                
                //SwiftSpinner.hide()
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                    //check for fundamental networking error
                    
                    print("error=\(error.debugDescription)")
                    self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
                }
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                //SwiftSpinner.hide()
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response.debugDescription)")
                }
                
                
            } else {
                
                //print("response = \(response)")
                //SwiftSpinner.hide()
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                do {
                    let resp = try (JSONSerialization.jsonObject(with: dataThis, options: []) as? [String:Any] ?? [:])
                    
                    print(resp)
                    
                    self.responseDict = resp["msg"] as? [String:Any] ?? [:]
                   
                    print(" First name is: \(self.responseDict)")
                    
                    for (ind,item) in self.responseDict.enumerated() {
                        print(ind)
                        //print(item)
                        
                        self.arrDictKeys1.append(item.key)
                        //self.arrDictKeys.append(item.key)
                        //self.arrDictValues.append([item.value])
                        
                        if item.key == "Bank Name" {
                            let arr = (item.value as! NSArray)[3] as? [String]
                            
                            self.arrDrop = arr ?? []
                            self.drop.options = self.arrDrop
                        }
                    }
                    
                    self.arrDictKeys = self.arrDictKeys1.sorted()
                    //print(self.arrDictKeys)
                    
                    for item in self.arrDictKeys {
                        let val = self.responseDict[item as? String ?? ""]
                        self.arrDictValues.append([val ?? []])
                    }
                    
                    // sameer 2/6/21
                    for (index,keyFld) in (self.arrDictKeys as! [String]).enumerated() {
                        let data = self.arrDictValues[index]
                        let arrData = data[0] as! Array<Any>
                        
                        if !((arrData[0] as? String) == "html") {
                        
                            if arrData[1] as? Int == 1 {
                                self.bankDict[keyFld] = ""
                                self.arrBankKeysMendatory.append(keyFld)
                            }else {
                                self.bankDict[keyFld] = ""
                                //self.arrBankKeysOptional.append(keyFld)
                            }
                            
                        }
                    }
                    
                    print(self.bankDict)
                    print(self.arrBankKeysMendatory)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.formTableView.dataSource = self
                        self.formTableView.delegate = self
                        
                        self.formTableView.reloadData()
                        //self.formTableView.tableFooterView = UIView()
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                    DispatchQueue.main.async() {
                        self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                    }
                }
                
            }
            
        }
        task.resume()
    }
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {
                
        if isHtml {
//            let vc = OrderFinalVC()
//            vc.orderID = self.placedOrderId
//            vc.finalPrice = self.finalPriced
//            vc.selectPaymentType = self.selectedPaymentType
//            vc.selectCurrency = self.selectedCurrency
//            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
            
            for key in self.arrBankKeysMendatory {
                
                if self.bankDict[key] as? String == "" {
                    
                    if key == "tnc" {

                        DispatchQueue.main.async {
                            self.view.makeToast("Please agree Terms & Conditions", duration: 2.0, position: .bottom)
                        }
                        
                        return
                    }else if key == "Bank Name" {
                        
                        DispatchQueue.main.async {
                            self.view.makeToast("Please select \(key)", duration: 2.0, position: .bottom)
                        }
                        
                        return
                    }else {

                        DispatchQueue.main.async {
                            self.view.makeToast("Please Enter \(key)", duration: 2.0, position: .bottom)
                        }
                        
                        return
                    }
                    
                }
                
            }
            
            
            
            /*
            for (index,keyFld) in (arrDictKeys as! [String]).enumerated() {
                
                let data = self.arrDictValues[index]
                let arrData = data[0] as! Array<Any>
                
                if (arrData[0] as? String) == "text" {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.formTableView.cellForRow(at: ndx) as! TextBoxCell
                    
                    if cell.txtField.text?.isEmpty ?? false && arrData[1] as! Int == 1 {
                        
                        self.view.makeToast("Please Enter \(arrData[2])", duration: 2.0, position: .bottom)
                                                
                        return
                    }else {
                        setInfo[keyFld] = cell.txtField.text
                    }
                    
                }else if (arrData[0] as? String) == "html" {
                    
                    //let ndx = IndexPath(row:index, section: 0)
                    //let cell = self.tableView.cellForRow(at: ndx) as! HtmlCell
                    
                }else if (arrData[0] as? String) == "select" && arrData[1] as! Int == 1 {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.formTableView.cellForRow(at: ndx) as! SelectTextCell
                    
                    if cell.selectTextField.text?.isEmpty ?? false {
                        
                        self.view.makeToast("Please select your bank", duration: 2.0, position: .bottom)
                        
                        return
                    }else {
                        
                        setInfo[keyFld] = cell.selectTextField.text
                    }
                    
                }else if (arrData[0] as? String) == "mobile" && arrData[1] as! Int == 1 {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.formTableView.cellForRow(at: ndx) as! MobileNumberCell
                    
                    if cell.mobileNumberTxtField.text?.isEmpty ?? false {
                        
                        self.view.makeToast("Please enter mobile number", duration: 2.0, position: .bottom)
                                                
                        return
                    }else {
                        
                        setInfo[keyFld] = cell.mobileNumberTxtField.text
                    }
                    
                }
                
            }
            */
            
            
            
            
            //setInfo["cartId"] = self.tradeOrderId
            //self.bankDetails = setInfo
            
            self.bankDict["cartId"] = self.tradeOrderId
            self.bankDetails = self.bankDict
            
            self.setMaxisFormToServer()
        }
        
    }
    
    func setMaxisFormToServer() {
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
        
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        var request = URLRequest(url: URL(string: "\(self.endPoint)/setMaxisForm")!)
        print("endpoint= \(endPoint)")
        request.httpMethod = "POST"
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: self.bankDetails, options:[])
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        let postString = "userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&formData=\(jsonString)"
        print("postString= \(postString)")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                self.hud.dismiss()
            }
            
            guard let dataThis = data, error == nil else {
                //SwiftSpinner.hide()
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                    //check for fundamental networking error
                    print("error=\(error.debugDescription)")
                    
                    self.view.makeToast("Please Check Internet conection.", duration: 2.0, position: .bottom)
                }
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                //SwiftSpinner.hide()
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response.debugDescription)")
                
            } else {
                
                //print("response = \(response)")
                //SwiftSpinner.hide()
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                do {
                    let json = try JSON(data: dataThis)
                    print(json)
                    
                    if json["status"].string == "Success" {
                        
                        DispatchQueue.main.async {
                            
                            if let success = self.formSubmit {
                                success(self.bankDetails)
                                self.dismiss(animated: false, completion: nil)
                            }
                         
                        }
                      
                    }else {
                        
                        DispatchQueue.main.async {
                            self.view.makeToast("Something went wrong!!".localized, duration: 2.0, position: .bottom)
                        }
                        
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
    
    @objc func selectBankNameButtonClicked(_ sender: UITextField) {
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDrop
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            //sender.setTitle(item, for: .normal)
            sender.text = item
        }
        existingFileDropDown.show()
    }
    
    //MARK:- tableview Delegates methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDictValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = self.arrDictValues[indexPath.row]
        
        let arrData = data[0] as? Array<Any>
        
        if (arrData?[0] as? String) == "text" {
            
            isHtml = false
            
            let cellTextBox = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell", for: indexPath) as! TextBoxCell
            
            cellTextBox.txtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellTextBox.txtField.tag = indexPath.row
            cellTextBox.txtField.delegate = self
            
            
            cellTextBox.txtField.layer.cornerRadius = 5.0
            cellTextBox.txtField.layer.borderWidth = 1.0
            cellTextBox.txtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellTextBox.seperatorLbl.backgroundColor = .clear
            
            return cellTextBox
            
        }else if (arrData?[0] as? String) == "html" {
            
            self.formTableView.isScrollEnabled = true
                        
            let cellTextHtml = tableView.dequeueReusableCell(withIdentifier: "HtmlCell", for: indexPath) as! HtmlCell
            cellTextHtml.htmlTextView.attributedText =  (arrData?[3] as? String)?.htmlToAttributedString
            
            return cellTextHtml
            
        }else if (arrData?[0] as? String) == "select" {
            
            isHtml = false
            
            let cellTextSelect = tableView.dequeueReusableCell(withIdentifier: "SelectTextCell", for: indexPath) as! SelectTextCell
            
            cellTextSelect.selectTextField.tag = indexPath.row
            cellTextSelect.selectTextField.delegate = self
            cellTextSelect.selectTextField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellTextSelect.selectTextField.addTarget(self, action: #selector(selectBankNameButtonClicked(_:)), for: .editingDidBegin)
            
            cellTextSelect.selectTextField.layer.cornerRadius = 5.0
            cellTextSelect.selectTextField.layer.borderWidth = 1.0
            cellTextSelect.selectTextField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellTextSelect.seperatorLbl.backgroundColor = .clear
            
            return cellTextSelect
            
        }else if (arrData?[0] as? String) == "mobile" {
            
            isHtml = false
            
            let cellMobNum = tableView.dequeueReusableCell(withIdentifier: "MobileNumberCell", for: indexPath) as! MobileNumberCell
            
            if let imgURL = URL.init(string: self.responseDictIN["paymentImage"] as? String ?? "") {
                //cellMobNum.paymentImgView.sd_setImage(with: imgURL)
                cellMobNum.paymentImgView.af_setImage(withURL: imgURL)
            }
            
            
            cellMobNum.mobileNumberTxtField.layer.cornerRadius = 5.0
            cellMobNum.mobileNumberTxtField.layer.borderWidth = 1.0
            cellMobNum.mobileNumberTxtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellMobNum.seperatorLbl.backgroundColor = .clear
            
            
            cellMobNum.mobileNumberTxtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellMobNum.mobileNumberTxtField.tag = indexPath.row
            cellMobNum.mobileNumberTxtField.delegate = self
            
            return cellMobNum
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    
    //MARK:- UITextField Delegates methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //if CustomUserDefault.getCurrency() == "RM" {
            self.placeHold = textField.placeholder ?? ""
        //}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // sameer 11/6/21
        let ndx = IndexPath(row: textField.tag, section: 0)
        if let cell = self.formTableView.cellForRow(at: ndx) as? TextBoxCell {
            if cell.txtField.text?.isEmpty ?? false {
                self.bankDict[cell.txtField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.txtField.text ?? ""
            }
        }
        
        if let cell = self.formTableView.cellForRow(at: ndx) as? SelectTextCell {
            if cell.selectTextField.text?.isEmpty ?? false {
                self.bankDict[cell.selectTextField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.selectTextField.text ?? ""
            }
        }
        
        if let cell = self.formTableView.cellForRow(at: ndx) as? MobileNumberCell {
            if cell.mobileNumberTxtField.text?.isEmpty ?? false {
                self.bankDict[cell.mobileNumberTxtField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.mobileNumberTxtField.text ?? ""
            }
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

