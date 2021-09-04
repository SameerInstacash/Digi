//
//  FailedViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 23/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit

class FailedViewController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameText: UILabel!
    var productImage = ""
    var productName = ""
    var functional1 = "Failed"
    var functional = "Device Body"
    
    @IBOutlet weak var functional1Label: UILabel!
    @IBOutlet weak var functionalLabel: UILabel!
    
    
    @IBAction func homeClicked(_ sender: Any) {
        let imei = UserDefaults.standard.string(forKey: "imei_number")!
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
        vc.IMEINumber = imei
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
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
        functional1Label.text = functional1
        functionalLabel.text = functional
        productNameText.text = productName
        let img = URL(string: productImage)
               self.downloadImage(url: img!)
        // Do any additional setup after loading the view.
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
                self.productImageView.image = UIImage(data: data)
            }
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

}
