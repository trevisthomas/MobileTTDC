//
//  AutoCompleteViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class AutoCompleteViewCell: UICollectionViewCell {
    var titleText : String = "" {
        didSet{
//            label.attributedText = titleText
            
            //Check out FlatCollectionView and extract that code for creatint attributed text into an extention or something
            textView.setHtmlText(titleText) 
        }
    }

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
