//
//  AutoCompleteCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class AutoCompleteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var threadTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        backgroundColor = style.postBackgroundColor()
        tintColor = style.tintColor()
        
        threadTitleLabel.textColor = style.entryTextColor()
    }

}
