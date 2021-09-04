//
//  CheckConditionViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 23/03/20.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//

import UIKit

class CheckConditionViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var samples: UILabel!
    @IBOutlet weak var failed: UILabel!
    @IBOutlet weak var flawless: UILabel!
    var obstacleViews : [UILabel] = []
    var productName = ""
    var productImage = ""
    var selection = 0
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        obstacleViews.append(flawless)
        obstacleViews.append(failed)
        obstacleViews.append(samples)
        
        
        let isEmp = UserDefaults.standard.bool(forKey: "isEmp")
        if isEmp {
            // Trade Up
            self.navItem.title = "Digi Trade-Up"
          
        }else {
            // Trade In
            self.navItem.title = "Digi Trade-In"
            
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            testTouches(touches: touches)
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!) {
            testTouches(touches: touches)
        }
        
        
        
        func testTouches(touches: Set<UITouch>) {
            // Get the first touch and its location in this view controller's view coordinate system
            let touch = touches.first as! UITouch
            let touchLocation = touch.location(in: self.view)
            var finalFlag = true
            
            for (index,obstacleView) in obstacleViews.enumerated() {
                // Convert the location of the obstacle view to this view controller's view coordinate system
                let obstacleViewFrame = self.view.convert(obstacleView.frame, from: obstacleView.superview)
                
                // Check if the touch is inside the obstacle view
                if obstacleViewFrame.contains(touchLocation) {
                    switch index{
                    case 0:
                        flawless.backgroundColor = UIColor(hexString: "#fedb00")
                        failed.backgroundColor = UIColor(hexString: "#EFEFF4")
                        
                        selection = 1
                    case 1:
                        failed.backgroundColor = UIColor(hexString: "#fedb00")
                        flawless.backgroundColor = UIColor(hexString: "#EFEFF4")
                        selection = 2
                    case 2:
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SampleVC") as! SamplePicsViewController
                        vc.productName = self.productName
                        vc.productImage = self.productImage
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                    default:
                        flawless.backgroundColor = UIColor(hexString: "#fedb00")
                        failed.backgroundColor = UIColor(hexString: "#EFEFF4")
                        selection = 1
                    }
                }
            }
        }

    
    @IBAction func continueclicked(_ sender: Any) {
        if selection == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // change 2 to desired number of
                
                /*
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeVC") as! EmployeeDetailsViewController
                vc.productName = self.productName
                vc.productImage = self.productImage
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                */
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SmartExMainVC") as! SmartExMainVC
                vc.productName = self.productName
                vc.productImage = self.productImage
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                
            }
        }else if selection == 2{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FailedVC") as! FailedViewController
                vc.productName = self.productName
                vc.productImage = self.productImage
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }
        }else {
            self.view.makeToast("Please select an option first", duration: 2.0, position: .bottom)
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
