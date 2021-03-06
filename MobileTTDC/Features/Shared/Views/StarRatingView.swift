//
//  StarRatingView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/2/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class StarRatingView: UIView {

    @IBInspectable var fillColor : UIColor = UIColor.green
    @IBInspectable var strokeColor : UIColor = UIColor.blue
    @IBInspectable var bgColor : UIColor = UIColor.white
    @IBInspectable var strokeWidth : CGFloat = 0.8
    
    @IBInspectable var starCount: Int = 5
    
    @IBInspectable var starsVisible: CGFloat = 1.5 //Must be less than star count!
    
    var starPoints : [CGPoint] = StarRatingView.loadStars()
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        backgroundColor = UIColor.clear
        fillColor = style.starFill()
        strokeColor = style.starStroke()
        bgColor = style.postBackgroundColor()
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        assert(starsVisible <= CGFloat(starCount))
        
//        let starWidth = rect.width / CGFloat(starCount)
        let starWidth = rect.height
        
        let starFillPath = UIBezierPath()
        starFillPath.fill()
        fillColor.setFill()
        
        
        var shiftBy : CGFloat = 0.0
        
        for _ in 0..<starCount {
            starFillPath.move(to: scalePoint(starPoints[0], scale: starWidth, shiftBy: shiftBy))
            for i in 1..<starPoints.count {
                let pt = starPoints[i]
                starFillPath.addLine(to: scalePoint(pt, scale: starWidth, shiftBy: shiftBy))
                
            }
            
            shiftBy += starWidth
            starFillPath.close()
        }
        
        starFillPath.fill()
        
        starFillPath.lineWidth = strokeWidth
        
        let mask = UIBezierPath(rect: rect.offsetBy(dx: starWidth * starsVisible,dy: 0))
        
        bgColor.setFill()
        mask.fill()
        
        strokeColor.setStroke()
        starFillPath.stroke()
        
        
    }
    
    func scalePoint(_ point : CGPoint, scale : CGFloat, shiftBy shift : CGFloat) -> CGPoint{
        return CGPoint(x: (point.x / 14 * scale) + shift, y: point.y / 14 * scale)
    }
    
    static func loadStars() -> [CGPoint]{
        var pts : [CGPoint] = []
        
        pts.append(CGPoint(x: 6.5, y: 0))
        pts.append(CGPoint(x: 5.0, y: 5.0))
        pts.append(CGPoint(x: 0, y: 5.5))
        pts.append(CGPoint(x: 3.5, y: 9))
        pts.append(CGPoint(x: 2, y: 14))
        pts.append(CGPoint(x: 6.5, y: 11.5))
        pts.append(CGPoint(x: 12, y: 14))
        pts.append(CGPoint(x: 10.5, y: 9))
        pts.append(CGPoint(x: 14, y: 5.5))
        pts.append(CGPoint(x: 9, y: 5))
        
        return pts
    }
}
