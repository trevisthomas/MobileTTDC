//
//  UIView+Nib.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

//http://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
//extension UIView {
//    class func fromNib<T : UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: T()), owner: nil, options: nil)![0] as! T
//    }
//}
//Trevis, after Swift 3 / iOS 10 conversion this stopped working.
//                    let review : MovieReviewSubView = MovieReviewSubView.fromNib()
// Below was the fix
//let nib = UINib(nibName: "MovieReviewSubView", bundle: nil)
//let review = nib.instantiate(withOwner: nil, options: nil)[0] as! MovieReviewSubView
