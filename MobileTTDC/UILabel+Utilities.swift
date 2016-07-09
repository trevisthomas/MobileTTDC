//
//  UILabel+Utilities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/9/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

//Trevis: Figure out how to share this logic between TextView and Label
extension UILabel {
    func setHtmlText(html : String, font sysfont : UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)){
        //        let sysfont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        let modifiedFont = NSString(format:"<span style=\"font-family: '\(sysfont.fontName)'; font-size: \(sysfont.pointSize)\">%@</span>", html) as String
        
        if let htmlData = modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding) {
            //                NSAttributedString(
            
            do {
                
                self.attributedText = try NSMutableAttributedString(data: htmlData,
                                                                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: sysfont],
                                                                    documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't translate \(html): \(e.localizedDescription) ")
            }
        }
    }
    
}