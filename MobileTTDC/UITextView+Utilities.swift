//
//  UITextView+Utilities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func customSizeThatFits(width: CGFloat) -> CGSize {
        
        let templateSize = CGSizeMake(width, CGFloat.max)
        let textRect = self.attributedText.boundingRectWithSize(templateSize, options: [NSStringDrawingOptions.UsesFontLeading,.UsesLineFragmentOrigin], context: nil)
        
        return textRect.size
        
    }
    
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