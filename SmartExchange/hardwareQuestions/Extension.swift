//
//  Extension.swift
//  SmartExchange
//
//  Created by Sameer Khan on 10/07/21.
//  Copyright © 2021 InstaCash. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setStatusBarColor() {
        if #available(iOS 13.0, *) {
            
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8588235294, blue: 0, alpha: 1)
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8588235294, blue: 0, alpha: 1)
            
        }
    }

}
