//
//  LoadingCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        registerForStyleUpdates() //causes refreshStyle to be called
       
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        backgroundColor = style.underneath()
        loadingLabel.textColor = style.entryTextColor()
        loadingActivity.color = style.entryTextColor()
    }


}
