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
    let selectionView = UIView()
    
    var item : AutoCompleteItem! {
        didSet{
            let style = getApplicationContext().getCurrentStyle()
            if(item.postId == nil) {
                self.contentLabel.setHtmlText("Create: \(item.displayTitle)", fuckingColor: style.attributedTextLabelColor())
//                self.textViewBecauseLabelsBehaveWeird.text = "Create: \(item.displayTitle)"
            } else {
                self.contentLabel.setHtmlText(item.displayTitle, fuckingColor: style.attributedTextLabelColor())
//                self.textViewBecauseLabelsBehaveWeird.text = item.displayTitle
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = selectionView
        registerForStyleUpdates()
        
        
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        backgroundColor = style.postBackgroundColor()
        tintColor = style.tintColor()
//        contentLabel.highlightedTextColor = UIColor.orangeColor()
        
        selectionView.backgroundColor = style.selectionColor()
        
        
        
        contentLabel.backgroundColor = style.postBackgroundColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
