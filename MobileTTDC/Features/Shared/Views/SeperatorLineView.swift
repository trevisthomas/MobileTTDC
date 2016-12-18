//
//  SeperatorLineView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class SeperatorLineView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
        backgroundColor = getApplicationContext().getCurrentStyle().postFooterBackgroundColor()
        self.setNeedsDisplay()
    }

}
