//
//  PostSeperator.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/23/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class PostSeperator: UIView {

//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        
//    }
//    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var thickness: CGFloat = 3.0
    
    override func drawRect(rect: CGRect) {
        //create the path
        let plusPath = UIBezierPath()
//        fillColor.setFill()
//        plusPath.fill()

        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = thickness
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x: 0,
            y: rect.height))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:rect.width,
            y:rect.height))
        
        //set the stroke color
        fillColor.setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }
}
