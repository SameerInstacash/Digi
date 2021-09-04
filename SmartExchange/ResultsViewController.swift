//
//  ResultsViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 05/04/18.
//  Copyright © 2018 ZeroWaste. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var FailedView: UIView!
    @IBOutlet weak var SuccessView: UIView!
    
    override func viewDidLoad() {
        self.setStatusBarColor()
        
        super.viewDidLoad()
        
        let textView = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
        self.automaticallyAdjustsScrollViewInsets = false
        
        textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.blue
        textView.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view.
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

}
