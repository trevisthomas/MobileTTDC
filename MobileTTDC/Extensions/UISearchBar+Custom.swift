//
//  UISearchBar+Custom.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

public extension UISearchBar {
    public func setTextColor(_ color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
    public func setTextBackgroundColor(_ color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.backgroundColor = color
    }
}
