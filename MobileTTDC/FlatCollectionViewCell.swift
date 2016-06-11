//
//  FlatCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class FlatCollectionViewCell: UICollectionViewCell {
    
    
    var post : Post!{
        didSet{
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            contentWebView.scrollView.scrollEnabled = false
            contentWebView.loadHTMLString(post.entry, baseURL: nil)
            
            
            
//            labelForSizing.text = post.entry
            let sysfont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            
            
            
            let modifiedFont = NSString(format:"<span style=\"font-family: '\(sysfont.fontName)'; font-size: \(sysfont.pointSize)\">%@</span>", post.entry) as String
            
            if let htmlData = modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding) {
//                NSAttributedString(
                
                do {
                    
                    entryTextView.attributedText = try NSMutableAttributedString(data: htmlData,
                                                                      options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: sysfont],
                                                                      documentAttributes: nil)
                    
                    labelForSizing.attributedText = entryTextView.attributedText
                } catch let e as NSError {
                    print("Couldn't translate \(post.entry): \(e.localizedDescription) ")
                }
            }
            
            
            
//            print("Lable size \(labelForSizing.intrinsicContentSize())")
            
//            contentWebView.frame = CGRectMake(0, 0,  CGFloat.max, 1);
//            contentWebView.sizeToFit()
            
            threadTitleButton.setTitle(post.title, forState: UIControlState.Normal)
            
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            
//            contentWebView.setNeedsLayout()
//            contentWebView.layoutIfNeeded()
            
        
  //          print("scrollZize: \(contentWebView.scrollView.contentSize.height)")
            
            
            contentWebView.scrollView.contentSize.height = 1
//            contentWebView.frame.height = 1
//            let heightString = contentWebView.stringByEvaluatingJavaScriptFromString("document.height")
//            print("heightString: \(heightString)")
            
            
            
            
//            contentWebView.delegate = self
            
//            var frame : CGRect = contentWebView.frame;
//            frame.size.height = 1;
//            contentWebView.frame = frame;
//            let fittingSize = contentWebView.sizeThatFits(CGSizeZero)
//            frame.size = fittingSize;
//            contentWebView.frame = frame;
            
            
//        print("fittingSize: \(fittingSize)")
//            print("Size of web that fits: \(contentWebView.sizeThatFits(CGSizeZero))")
//            print("Size of web: \(contentWebView.intrinsicContentSize())")
//            print("Size of btn: \(dateButton.intrinsicContentSize())")
        }
    }

    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var labelForSizing: UILabel!
    @IBOutlet weak var contentWebView: UIWebView! {
        didSet{
            contentWebView.delegate = self //For url behaviors initially at least.
        }
    }
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
     //   print("did finish ScrollHeight: \(contentWebView.scrollView.contentSize.height)")
    }
    
    

    

}

extension FlatCollectionViewCell {
    func preferredHeight(width : CGFloat) -> CGFloat {
        
        self.invalidateIntrinsicContentSize()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        let sizeThatFits = labelForSizing.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits too \(sizeThatFits2)")
        
//        let sizeThatFits = entryTextView.layoutManager.usedRectForTextContainer(entryTextView.textContainer).size
        print("Size that fits \(sizeThatFits)")
        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
        
        
    }
}


extension FlatCollectionViewCell : UITextViewDelegate {
    //http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        print("\(URL.absoluteString)")
        return true;
    }
}


//** Move this extension!!
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

