//
//  HotboxView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

//@IBDesignable
class HotboxView: UIView {
    
    //    // Only override draw() if you perform custom drawing.
    //    // An empty implementation adversely affects performance during animation.
    //    override func draw(_ rect: CGRect) {
    //        // Drawing code
    //
    //    }
    //
//    @IBInspectable var fillColor: UIColor = UIColor.green
//    @IBInspectable var thickness: CGFloat = 2.123
//    @IBInspectable var strokeColor : UIColor = UIColor.orange
    
    var fillColor: UIColor = UIColor.yellow
    fileprivate var thickness: CGFloat = 0.5
    var strokeColor : UIColor = UIColor.orange
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
//        backgroundColor = UIColor.clear
//        fillColor = getApplicationContext().getCurrentStyle().postFooterDetailColor()
        
        let style = getApplicationContext().getCurrentStyle()
        fillColor = style.postFooterBackgroundColor()
        
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //create the path
        let plusPath = UIBezierPath()
        //        fillColor.setFill()
        //        plusPath.fill()
        
        
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = thickness
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        
        plusPath.move(to: CGPoint(x: 0, y: 0))
        plusPath.addLine(to: CGPoint(
            x: 0,
            y: rect.height))
        
        plusPath.addLine(to: CGPoint(
            x: rect.width,
            y: rect.height))
        
        plusPath.addLine(to: CGPoint(
            x: rect.width, y: 0))
        
//        plusPath.addLine(to: CGPoint(x: 0, y: 0))
        
        
        
        plusPath.close()
        
        
//        //add a point to the path at the end of the stroke
//        plusPath.addLine(to: CGPoint(
//            x:rect.width,
//            y:rect.height))
        
        
        fillColor.setFill()
        plusPath.fill()
        
        let linePath = UIBezierPath()
        linePath.lineWidth = thickness
        
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(
            x: rect.width,
            y: 0))
        
        
        linePath.move(to: CGPoint(x: 0, y: rect.height))
        linePath.addLine(to: CGPoint(
            x: rect.width,
            y: rect.height))
        
//        strokeColor.setStroke()
//        plusPath.stroke()
        
        
        strokeColor.setStroke()
        linePath.stroke()
        
    }
}
