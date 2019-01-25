//
//  BtcRateTableViewCell.swift
//  btcwatch
//
//  Created by skrr on 24.01.19.
//  Copyright © 2019 MSt. All rights reserved.
//

import UIKit

class BtcRateTableViewCell: UITableViewCell {
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var exchangeRate: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
