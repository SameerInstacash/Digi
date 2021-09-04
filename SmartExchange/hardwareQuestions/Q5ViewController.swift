//
//  Q5ViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 24/04/18.
//  Copyright © 2018 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON

class Q5ViewController: UIViewController {

    @IBOutlet weak var ans1view: UILabel!
    @IBOutlet weak var ans2view: UILabel!
    @IBOutlet weak var ans3view: UILabel!
    @IBOutlet weak var ans4view: UILabel!
    @IBOutlet weak var ans5view: UILabel!
    
    
    @IBOutlet weak var questNameView: UILabel!
    
    
    
    var obstacleViews : [UILabel] = []
    var appCodeStr: String = ""
    var resultJSON = JSON()
    var endPoint = "http://exchange.getinstacash.in/store-asia/api/v1/public/"
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        if self.endPoint.range(of:"store-asia") != nil || self.endPoint.range(of:"stores-asia") != nil || self.endPoint.range(of:"asurionre") != nil || self.endPoint.range(of:"seatest") != nil{
            self.questNameView.text = "Device Body (Side & Back Cover)"
        }
        obstacleViews.append(ans1view)
        obstacleViews.append(ans2view)
        obstacleViews.append(ans3view)
        obstacleViews.append(ans4view)
        obstacleViews.append(ans5view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    if(!appCodeStr.contains("CPBP01")){
                    appCodeStr = "\(appCodeStr);CPBP01"
                        UserDefaults.standard.set("Flawless", forKey: "back")
                    }
                    ans1view.backgroundColor = UIColor(hexString: "#fedb00")
                case 1:
                    if(!appCodeStr.contains("CPBP02")){
                    appCodeStr = "\(appCodeStr);CPBP02"
                        UserDefaults.standard.set("Minor Scratches", forKey: "back")
                    }
                    ans2view.backgroundColor = UIColor(hexString: "#fedb00")
                case 2:
                    if(!appCodeStr.contains("CPBP03")){
                    appCodeStr = "\(appCodeStr);CPBP03"
                        UserDefaults.standard.set("Heavy Scratches", forKey: "back")
                    }
                    ans3view.backgroundColor = UIColor(hexString: "#fedb00")
                case 3:
                    if(!appCodeStr.contains("CPBP05")){
                    appCodeStr = "\(appCodeStr);CPBP05"
                        UserDefaults.standard.set("Cracked", forKey: "back")
                    }
                    ans4view.backgroundColor = UIColor(hexString: "#fedb00")
                    
                case 4:
                    if(!appCodeStr.contains("CPBP04")){
                        appCodeStr = "\(appCodeStr);CPBP04"
                        UserDefaults.standard.set("Dented", forKey: "back")
                    }
                    ans5view.backgroundColor = UIColor(hexString: "#fedb00")
                default:
                    if(!appCodeStr.contains("CPBP01")){
                    appCodeStr = "\(appCodeStr);CPBP01"
                        UserDefaults.standard.set("Flawless", forKey: "back")
                    }
                    ans1view.backgroundColor = UIColor(hexString: "#fedb00")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of
                    self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
//                     if self.endPoint.range(of:"store-asia") != nil || self.endPoint.range(of:"stores-asia") != nil || self.endPoint.range(of:"asurionre") != nil || self.endPoint.range(of:"seatest") != nil{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserVC") as! UserDetailsViewController
//                        vc.appCodeStr = self.appCodeStr
//                        vc.resultJOSN = self.resultJSON
//                        self.present(vc, animated: true, completion: nil)
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PriceVC") as! PriceViewController
                    vc.appCodeStr = self.appCodeStr
                    vc.resultJOSN = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
//                     }else{
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Q6VC") as! Q6ViewController
//                        vc.appCodeStr = self.appCodeStr
//                        vc.resultJSON = self.resultJSON
//                        self.present(vc, animated: true, completion: nil)
//                    }
                }
                
            }
            
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




