//
//  AutoCompleteTableViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/9/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class AutoCompleteTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    var autoCompleteText : String! {
        didSet{
            self.contentLabel.setHtmlText(autoCompleteText)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
