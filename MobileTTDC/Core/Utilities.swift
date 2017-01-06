//
//  Utilities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

func invokeLater(_ completion : @escaping () -> ()) {
    DispatchQueue.main.async {
        completion()
    }
}

func getApplicationContext() -> ApplicationContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.applicationContext
}

func getAppDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func addBlurEffect(view : UIView) {
    view.backgroundColor = UIColor.clear
    let blurEffect = UIBlurEffect(style: getApplicationContext().getCurrentStyle().blurEffectStyle())
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    view.sendSubview(toBack: blurEffectView)
}

open class Utilities{
    
    open static let singleton : Utilities = Utilities()
    
    let simpleDateFormatter : DateFormatter
    let simpleDateTimeFormatter : DateFormatter
    
    init () {
        simpleDateFormatter = DateFormatter()
        simpleDateFormatter.locale = Locale(identifier: "en_US")
        simpleDateFormatter.dateStyle = .medium
        simpleDateFormatter.timeStyle = .none
        
        simpleDateTimeFormatter = DateFormatter()
        simpleDateTimeFormatter.locale = Locale(identifier: "en_US")
        simpleDateTimeFormatter.dateFormat = "MMM d yyyy, h:mm a"
    }
    
    
    
    func simpleDateFormat(_ date: Date) -> String{
        return simpleDateFormatter.string(from: date)
    }
    
    func simpleDateTimeFormat(_ date: Date) -> String{
        return simpleDateTimeFormatter.string(from: date)
    }
    
}
