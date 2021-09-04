//
//  FirstQViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 24/04/18.
//  Copyright © 2018 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON

class FirstQViewController: UIViewController {

    
    @IBOutlet weak var ans1view: UILabel!
    @IBOutlet weak var ans2view: UILabel!
    @IBOutlet weak var ans3view: UILabel!
    @IBOutlet weak var ans4view: UILabel!
    @IBOutlet weak var ans5view: UILabel!
    
    @IBOutlet weak var questNameView: UILabel!
    
    
    var obstacleViews : [UILabel] = []
    var appCodeStr = "STON01;"
    var isBrk = false
    var resultJSON = JSON()
    var endPoint = "http://exchange.getinstacash.in/store-asia/api/v1/public/"
    
    
    
    
    override func viewDidLoad() {
        
        self.setStatusBarColor()
        
        super.viewDidLoad()
        isBrk = UserDefaults.standard.bool(forKey: "deadPixel") && UserDefaults.standard.bool(forKey: "screen")
        self.endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        if (self.endPoint.range(of:"store-asia") != nil) || self.endPoint.range(of:"stores-asia") != nil || self.endPoint.range(of:"asurionre") != nil || self.endPoint.range(of:"seatest") != nil{
            self.questNameView.text = "LCD / Screen Glass"
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
                    if(!isBrk){
                        if(!appCodeStr.contains("SBRK01")){
                            appCodeStr = "\(appCodeStr)SBRK01"
                            UserDefaults.standard.set("Not Working", forKey: "lcd")
                        }
                    }else{
                        if(!appCodeStr.contains("SPTS01")){
                            appCodeStr = "\(appCodeStr)SPTS01"
                            UserDefaults.standard.set("Flawless", forKey: "lcd")
                        }
                    }
                    ans1view.backgroundColor = UIColor(hexString: "#fedb00")
                case 1:
                    if(!isBrk){
                        if(!appCodeStr.contains("SBRK01")){
                            appCodeStr = "\(appCodeStr)SBRK01"
                            UserDefaults.standard.set("Not Working", forKey: "lcd")
                        }
                    }else{
                        if(!appCodeStr.contains("SPTS02")){
                            appCodeStr = "\(appCodeStr)SPTS02"
                            UserDefaults.standard.set("2-3 Minor Scratches", forKey: "lcd")
                        }
                    }
                    ans2view.backgroundColor = UIColor(hexString: "#fedb00")
                case 2:
                    if(!isBrk){
                        if(!appCodeStr.contains("SBRK01")){
                            appCodeStr = "\(appCodeStr)SBRK01"
                            UserDefaults.standard.set("Not Working", forKey: "lcd")
                        }
                    }else{
                        if(!appCodeStr.contains("SPTS03")){
                            appCodeStr = "\(appCodeStr)SPTS03"
                            UserDefaults.standard.set("Heavily Scratched", forKey: "lcd")
                        }
                    }
                    ans3view.backgroundColor = UIColor(hexString: "#fedb00")
                case 3:
                    if(!appCodeStr.contains("SBRK01")){
                        print("SBRK01")
                        appCodeStr = "\(appCodeStr)SBRK01"
                        UserDefaults.standard.set("Not_Working".localized, forKey: "lcd")
                    }
                    ans4view.backgroundColor = UIColor(hexString: "#fedb00")
                    break
                case 4:
                    if(!isBrk){
                        if(!appCodeStr.contains("SBRK01")){
                            print("SBRK01")
                            appCodeStr = "\(appCodeStr)SBRK01"
                            UserDefaults.standard.set("Not_Working".localized, forKey: "lcd")
                        }
                    }else{
                        if(!appCodeStr.contains("SPTS04")){
                            print("SPTS04")
                            appCodeStr = "\(appCodeStr)SPTS04"
                            UserDefaults.standard.set("cracked".localized, forKey: "lcd")
                        }
                    }
                    ans5view.backgroundColor = UIColor(hexString: "#fedb00")
                default:
                    if(!isBrk){
                        if(!appCodeStr.contains("SBRK01")){
                            appCodeStr = "\(appCodeStr)SBRK01"
                            UserDefaults.standard.set("Not Working", forKey: "lcd")
                        }
                    }else{
                        if(!appCodeStr.contains("SPTS01")){
                            appCodeStr = "\(appCodeStr)SPTS01"
                            UserDefaults.standard.set("Flawless", forKey: "lcd")
                        }
                    }
                    ans1view.backgroundColor = UIColor(hexString: "#fedb00")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of
                    
//                    if self.endPoint.range(of:"store-asia") != nil || self.endPoint.range(of:"stores-asia") != nil || self.endPoint.range(of:"asurionre") != nil || self.endPoint.range(of:"seatest") != nil{
                    
                        if(!UserDefaults.standard.bool(forKey: "camera")){
                            self.appCodeStr = "\(self.appCodeStr);CISS01"
                        }
                        if(!UserDefaults.standard.bool(forKey: "volume")){
                            self.appCodeStr = "\(self.appCodeStr);CISS02;CISS03"
                        }
                        if(!UserDefaults.standard.bool(forKey: "connection")){
                            self.appCodeStr = "\(self.appCodeStr);CISS04"
                        }
                        if(!UserDefaults.standard.bool(forKey: "charger")){
                            self.appCodeStr = "\(self.appCodeStr);CISS05"
                        }
                        if(!UserDefaults.standard.bool(forKey: "earphone")){
                            self.appCodeStr = "\(self.appCodeStr);CISS11"
                        }
                        if(!UserDefaults.standard.bool(forKey: "fingerprint")){
                            self.appCodeStr = "\(self.appCodeStr);CISS12"
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Q4oVC") as! Q4optViewController
                        vc.appCodeStr = self.appCodeStr
                        vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
//                    }else{
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Q2VC") as! SecondQViewController
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

