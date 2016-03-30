//
//  CircleDiagram.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit

class CircleDiagram: UIView {
    
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcWidth:CGFloat = 30.0
    var arcColor = UIColor.yellowColor()
    var arcBackgroundColor = UIColor.clearColor()
    
    override func drawRect(rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        let colorspace = CGColorSpaceCreateDeviceRGB()
        //set line attributes

        
        //draw the arc
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextSetLineWidth(context, arcWidth * 0.8 )
        //CGContextSetLineWidth(context, arcWidth)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)

        CGContextStrokePath(context)
        
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, CGLineCap.Butt)
        //make the circle background
        
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        CGContextStrokePath(context)
        
    }
}
