//
//  CGSize+.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

extension CGSize{
    
    func toTuple() -> (Float, Float) {
        return (Float(self.width), Float(self.height))
    }
    
    static func fromTuple(tuple : (width : Float, height : Float)) -> CGSize{
        return CGSize(width: CGFloat(tuple.width), height: CGFloat(tuple.height))
        
    }
}

