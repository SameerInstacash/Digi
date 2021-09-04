//
//  PriceTblCell.swift
//  SmartExchange
//
//  Created by Sameer Khan on 01/07/21.
//  Copyright © 2021 ZeroWaste. All rights reserved.
//

import UIKit

class PriceTblCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
