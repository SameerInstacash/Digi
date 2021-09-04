//
//  DeadPixelVC.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 18/03/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import PopupDialog
import QRCodeReader
import AVFoundation
import SwiftGifOrigin
import AudioToolbox
import SwiftyJSON
import CoreMotion
import AVFoundation

class DeadPixelVC: UIViewController {

    @IBOutlet weak var startTestBtn: UIButton!
    var timer: Timer?
    var timerIndex = 0
    @IBOutlet weak var deadPixelInfoImage: UIImageView!
    @IBOutlet weak var deadPixelInfo: UILabel!
    var resultJSON = JSON()
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @objc func setRandomBackgroundColor() {
        timerIndex += 1
        let colors = [
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        ]
        switch timerIndex {
        case 5:
            self.view.backgroundColor = colors[0]
            timer?.invalidate()
            timer = nil
            
            
            // Prepare the popup assets
            let title = "Dead_Pixel_Test".localized
            let message = "dead_pixel_msg".localized
            
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = CancelButton(title: "Yes".localized) {
                self.resultJSON["Dead Pixels"].int = 0
                UserDefaults.standard.set(false, forKey: "deadPixel")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScreenVC") as! ScreenViewController
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            let buttonTwo = DefaultButton(title: "No".localized) {
                self.resultJSON["Dead Pixels"].int = 1
                UserDefaults.standard.set(true, forKey: "deadPixel")
                print("Dead Pixel Passed!")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScreenVC") as! ScreenViewController
                vc.modalPresentationStyle = .fullScreen
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            let buttonThree = DefaultButton(title: "Retry".localized) {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
                self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                self.startTestBtn.isHidden = true
                self.deadPixelInfo.isHidden = true
                self.deadPixelInfoImage.isHidden = true
                self.timerIndex = 0
            }
            
            
           
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo,buttonThree])
            popup.dismiss(animated: true, completion: nil)
            // Customize dialog appearance
            let pv = PopupDialogDefaultView.appearance()
            pv.titleFont    = UIFont(name: "HelveticaNeue-Medium", size: 20)!
            pv.messageFont  = UIFont(name: "HelveticaNeue", size: 16)!
            
            
            // Customize the container view appearance
            let pcv = PopupDialogContainerView.appearance()
            pcv.cornerRadius    = 2
            pcv.shadowEnabled   = true
            pcv.shadowColor     = .black
            
            // Customize overlay appearance
            let ov = PopupDialogOverlayView.appearance()
            ov.blurEnabled     = true
            ov.blurRadius      = 30
            ov.opacity         = 0.7
            ov.color           = .black
            
            // Customize default button appearance
            let db = DefaultButton.appearance()
            db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
            
            
            
            // Customize cancel button appearance
            let cb = CancelButton.appearance()
            cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
            
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
            break
            
        default:
            self.view.backgroundColor = colors[0]
        }
        
        
    }
    
   
        
    
    
    
    @IBAction func startDeadPixelTest(_ sender: AnyObject) {
        checkVibrator()
//        playSound()
        self.resultJSON["Speakers"].int = 1
        self.resultJSON["MIC"].int = 1
        self.navBar.isHidden = true
        UserDefaults.standard.set(true, forKey: "mic")
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
        self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.startTestBtn.isHidden = true
        self.deadPixelInfo.isHidden = true
        self.deadPixelInfoImage.isHidden = true
        
    }
    
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
         
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkVibrator(){
        let manager = CMMotionManager()
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x > 0.03  {
                     print("Device Vibrated")
                    self?.resultJSON["Vibrator"].int = 1
                    manager.stopDeviceMotionUpdates()
                }
            }
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func playUsingAVAudioPlayer(url: URL) {
        var audioPlayer: AVAudioPlayer?
        self.resultJSON["Speakers"].int = 1
        self.resultJSON["MIC"].int = 1
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            print("playing audio")
        } catch {
            print(error)
        }
    }
    
    func playSound() {
        DispatchQueue.main.async{
            print("playing the sound")
            guard let url = Bundle.main.path(forResource: "whistle", ofType: "mp3") else {
                print("not found")
                return
            }
            
            do {
                print("Playing Music")
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                
                self.audioPlayer.play()
                let outputVol = AVAudioSession.sharedInstance().outputVolume
                
                if(outputVol > 0.36){
                    self.resultJSON["Speakers"].int = 1
                    self.resultJSON["MIC"].int = 1
                    UserDefaults.standard.set(true, forKey: "mic")
                }else{
                    self.resultJSON["Speakers"].int = 0
                    self.resultJSON["MIC"].int = 0
                    UserDefaults.standard.set(false, forKey: "mic")
                    
                }
            } catch let error {
                print("Error Playing Music: \(error)")
                self.resultJSON["Speakers"].int = 0
                self.resultJSON["MIC"].int = 0
                UserDefaults.standard.set(false, forKey: "mic")
                print(error.localizedDescription)
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
