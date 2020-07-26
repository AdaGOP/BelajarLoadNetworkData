//
//  SecondCountryTableCellTableViewCell.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 05/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit
import WebKit

class SecondCountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagWebView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set initialization code
        
        flagWebView.contentMode = .scaleAspectFill
        flagWebView.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
