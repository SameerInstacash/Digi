//
//  EmployeeDetailsViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 23/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var employeeMobile: UITextField!
    @IBOutlet weak var employeeEmail: UITextField!
    @IBOutlet weak var employeeId: UITextField!
    var productName = ""
    var productImage = ""
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        let empId = employeeId.text ?? ""
        let empEmail = employeeEmail.text ?? ""
        let empMobile = employeeMobile.text ?? ""
        if empId.length > 0 {
            if isValidEmail(empEmail){
                if empMobile.length > 9 && empMobile.length < 12 {
                    UserDefaults.standard.set(empId, forKey: "empId")
                    UserDefaults.standard.set(empEmail, forKey: "empEmail")
                    UserDefaults.standard.set(empMobile, forKey: "empMobile")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SmartExMainVC") as! SmartExMainVC
                    vc.productName = self.productName
                    vc.productImage = self.productImage
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                        self.view.makeToast("Enter a valid Mobile Number", duration: 2.0, position: .bottom)
                }
            }else{
                    self.view.makeToast("Please Enter a valid Email Id", duration: 2.0, position: .bottom)
            }
        }else{
                self.view.makeToast("Please Enter a valid Employee Id", duration: 2.0, position: .bottom)
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            
        }
        
    }
    
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
