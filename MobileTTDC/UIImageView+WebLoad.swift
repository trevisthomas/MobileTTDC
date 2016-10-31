//
//  UIImageView+WebLoad.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


extension UIImageView {
    
    
    //http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let img = appDelegate.applicationContext.imageCache[link] {
            self.image = img
            print("Image cache hit \(link)")
            return
        }
        
        
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            
            self.getApplicationContext().imageCache[link] = image
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
