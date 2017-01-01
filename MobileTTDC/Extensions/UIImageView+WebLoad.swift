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
    func downloadedFrom(link rawLink:String, contentMode mode: UIViewContentMode) {
        guard let link = rawLink.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.image = nil
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let img = appDelegate.applicationContext.imageCache[link] {
            self.image = img
//            print("Image cache hit \(link)")
            return
        }
        
        
        guard let url = URL(string: link) else {
            print("Image url cant be found: \(link)")
            self.image = nil
            return
        }
        contentMode = mode
        
        print("Downloading image: \(link)")
        
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
        NetworkAdapter.getUrlSession().dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            self.getApplicationContext().imageCache[link] = image
            
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
