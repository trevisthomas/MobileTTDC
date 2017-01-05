//
//  UIViewController+AppDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/26/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

extension UIViewController {
    func getToken() -> String? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationContext.token
    }
    
    func presentAlert(_ title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func registerAndCreatePrototypeCellFromNib(_ withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.register(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UICollectionViewCell
    }
    
    func registerAndCreatePrototypeHeaderViewFromNib(_ withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UICollectionReusableView
    }
    
    func getCollectionView() -> UICollectionView? {
        return nil
    }
    
    
}



