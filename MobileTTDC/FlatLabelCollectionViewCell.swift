//
//  FlatLabelCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/5/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class FlatLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var entryWebView: UIWebView! {
        didSet{
            entryWebView.delegate = self
        }
    }
    
//    weak var parentCollectionView : UICollectionView!
    
    weak var parentViewController : HomeViewController!
    var rowIndex : Int!
    var maxCellWidth : CGFloat!
    
    var post : Post!{
        didSet{
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            threadTitleButton.setTitle(post.title, forState: UIControlState.Normal)
            
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            
            
            entryWebView.scrollView.scrollEnabled = false
            entryWebView.loadHTMLString(post.entry, baseURL: nil)
            
//            contentWebView.scrollView.scrollEnabled = false
//            contentWebView.loadHTMLString(post.entry, baseURL: nil)
            
            entryLabel.text = post.entry
            
//            entryLabel.frame.size.height = 1
            
            self.entryLabel.setNeedsLayout()
            self.entryLabel.layoutIfNeeded()
            
//            print("Lable size \(labelForSizing.intrinsicContentSize())")
            
            //            contentWebView.frame = CGRectMake(0, 0,  CGFloat.max, 1);
            //            contentWebView.sizeToFit()
            
            
            
            //            contentWebView.setNeedsLayout()
            //            contentWebView.layoutIfNeeded()
            
            
            //          print("scrollZize: \(contentWebView.scrollView.contentSize.height)")
            
            
//            contentWebView.scrollView.contentSize.height = 1
//            //            contentWebView.frame.height = 1
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

    
//    func preferredLayoutSizeFittingSize(targetSize: CGSize)-> CGSize {
//    
//        let originalFrame = self.frame
//        let originalPreferredMaxLayoutWidth = self.entryLabel.preferredMaxLayoutWidth
//        
//        
//        var frame = self.frame
//        frame.size = targetSize
//        self.frame = frame
//        
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        self.entryLabel.preferredMaxLayoutWidth = self.questionLabel.bounds.size.width
//        
//        
//        // calling this tells the cell to figure out a size for it based on the current items set
//        let computedSize = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//        
//        let newSize = CGSize(width:targetSize.width, height:computedSize.height)
//        
//        self.frame = originalFrame
//        self.questionLabel.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
//        
//        return newSize
//    }

  /*
    func preferredSize(targetSize: CGSize) -> CGSize {
        var size = targetSize
//        self.entryLabel.frame.size = targetSize
        self.entryLabel.preferredMaxLayoutWidth = targetSize.width
        self.entryLabel.setNeedsLayout()
        self.entryLabel.layoutIfNeeded()
        
//        entryWebView.setNeedsLayout()
//        entryWebView.layoutIfNeeded()
        
        
//        entryWebView.frame.size.width = targetSize.width
//        entryWebView.frame.size.height = 1
//        
//        entryWebView.sizeThatFits(<#T##size: CGSize##CGSize#>)
        
//
//        var ih = entryWebView.intrinsicContentSize().height
//        print(print("ih; \(ih)"))
        
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
        
        let h = self.entryLabel.frame.height
        
//        let s = self.intrinsicContentSize()
        
        
        print("h; \(h)")
//        print("s; \(s)")
        size.height = self.entryLabel.intrinsicContentSize().height + 64 + 8
//        size.height = self.entryLabel.frame.height + 50;
        
        return size;
    }
 */
   
//    var lastSize : CGSize!
    func webViewDidFinishLoad(webView: UIWebView) {
        var frame = entryWebView.frame
        
        
        
        if parentViewController != nil {
            
//            frame.size.width = maxCellWidth
            
            frame.size.width = parentViewController.view.frame.width
            print(rowIndex)
    //        frame.size.width = 375 //wtf
            frame.size.height = 1
            
            entryWebView.frame = frame
            let fittingSize = entryWebView.sizeThatFits(CGSizeZero)
            frame.size = fittingSize;
            entryWebView.frame = frame
            
    //        lastSize = fittingSize
            
            print("webViewDidFinishLoad \(fittingSize.height)" )
            parentViewController.sizeDictionary[rowIndex] = CGSize(width: fittingSize.width, height: fittingSize.height + 64 + 8 + 50)
            parentViewController.collectionView.collectionViewLayout.invalidateLayout()
            
        }
        
    }
    
    //Sizing madness based on
    //http://stackoverflow.com/questions/3936041/how-to-determine-the-content-size-of-a-uiwebview/11770883#11770883
    //http://stackoverflow.com/questions/23121663/resize-uicollectionview-cells-after-image-inside-has-been-downloaded
    
    //Basically i calculate the size in the webViewDidFinishLoad and then put those values into a dictionary that is owned by the controller.  Then i invalidate the layout.  It's slow as shit but it works better than anything else so far.
 
    
    func preferredSize(targetSize: CGSize) -> CGSize {
    
//        var frame = entryWebView.frame
//        frame.size.width = targetSize.width
//        frame.size.height = 1
//        
//        entryWebView.frame = frame
//        let fittingSize = entryWebView.sizeThatFits(CGSizeZero)
//        frame.size = fittingSize;
//        entryWebView.frame = frame
        
        
//        return CGSize(width: targetSize.width, height: fittingSize.height + 64 + 8)
        
        
        //Wont be accurate until *after* webViewDidFinishLoad
        
//        if lastSize != nil {
//            return CGSize(width: targetSize.width, height: lastSize.height + 64 + 8)
//        }
        
        //Deprecated
        return CGSize(width: targetSize.width, height: entryWebView.frame.height + 64 + 8)
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
