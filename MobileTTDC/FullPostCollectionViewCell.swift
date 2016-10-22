//
//  FullPostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/20/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class FullPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fullPostView: FullPostView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        fullPostView.awakeFromNib()
        // Initialization code
    }

    func setup(delegate : PostViewCellDelegate, post: Post){
        fullPostView.delegate = delegate
        fullPostView.post = post
    }
    
    func preferredHeight(width : CGFloat) -> CGFloat{
        return fullPostView.preferredHeight(width)
    }
}
