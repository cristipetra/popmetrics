//
//  CompletionView.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//
import UIKit

class CompletionView: UIView {
    
    var completedColor = PopmetricsColor.orange
    var uncompletedColor = UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.8)
    
    fileprivate var completionDegrees = 0
    
    
    //When creating the view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //When creating the view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCompletion(_ completion: Int, total: Int) {
        completionDegrees = getDegreesForCompletion(completion, total: total)
        setNeedsDisplay()
    }
    
    fileprivate func getDegreesForCompletion(_ completion: Int, total: Int) -> Int {
        // Considering that total represents 360 deg, calculate for the completion
        return (360 * completion) / total
    }
    
    override func draw(_ rect: CGRect) {
        // Draw the main circle
        uncompletedColor.setFill()
        let mainCirclePath = UIBezierPath(ovalIn: rect)
        mainCirclePath.fill()
        
        // Draw the arc and fill the area
        completedColor.setFill()
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let circleRadius = rect.width / 2
        let startDegrees: Float = (0 - 90)
        let endDegrees: Float = (Float(completionDegrees) - 90)
        
        let path = UIBezierPath()
        path.move(to: centerPoint)
        path.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: startDegrees.degreesToRadians, endAngle: endDegrees.degreesToRadians, clockwise: true)
        path.fill()
    }
}

extension Float {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}
