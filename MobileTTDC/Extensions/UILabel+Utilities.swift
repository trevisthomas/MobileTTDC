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
//    func setHtmlText(html : String, font sysfont : UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)){
//        //        let sysfont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        
//        let modifiedFont = NSString(format:"<span style=\"font-family: '\(sysfont.fontName)'; font-size: \(sysfont.pointSize)\">%@</span>", html) as String
//        
//        if let htmlData = modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding) {
//            //                NSAttributedString(
//            
//            do {
//                
//                self.attributedText = try NSMutableAttributedString(data: htmlData,
//                                                                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: sysfont],
//                                                                    documentAttributes: nil)
//            } catch let e as NSError {
//                print("Couldn't translate \(html): \(e.localizedDescription) ")
//            }
//        }
//    }
    
    
    func setHtmlText(_ html : String, fuckingColor: String, font sysfont : UIFont = UIFont(name:"Helvetica", size: UIFont.systemFontSize)!){
        //UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        //        let sysfont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        //UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        let fileLocation = Bundle.main.path(forResource: "style", ofType: "css")!
        let css : String
        do
        {
            css = try String(contentsOfFile: fileLocation)
        }
        catch
        {
            css = ""
        }
        //        print(css)
        
        //        sysfont = UIFont(name: "Verdana", size: 14.0)!
        
        let fontSyle = "<style type=\"text/css\"> body { font-size: \(sysfont.pointSize); font-family: \(sysfont.fontName); color: \(fuckingColor);} </style>"
        
        let htmlCss = "<html><head>\(css) \(fontSyle)</head><body>\(html)</body></html>"
        
        
        //        let modifiedFont = NSString(format:"<span style=\"font-family: '\(sysfont.fontName)'; font-size: \(sysfont.pointSize)\">%@  </span>", html) as String
        //
        
        if let htmlData = htmlCss.data(using: String.Encoding.unicode) {
            //                NSAttributedString(
            
            do {
                
                self.attributedText = try NSMutableAttributedString(data: htmlData,
                                                                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: sysfont],
                                                                    documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't translate \(html): \(e.localizedDescription) ")
            } catch let e2 as NSException {
                print("NSException while loading \(html): \(e2.debugDescription) ")
            }
        }
    }
}
