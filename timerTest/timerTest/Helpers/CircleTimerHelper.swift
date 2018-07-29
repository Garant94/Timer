//
//  CircleTimerHelper.swift
//  timerTest
//
//  Created by Taras on 28/07/2018.
//  Copyright © 2018 Taras. All rights reserved.
//

import Foundation
import UIKit

class CircleTimerHelper {
    
    static func pointFromAngle(angle: CGFloat, rect: CGRect, radius: CGFloat) -> CGPoint {
        
        let centerPoint = CGPoint(x: rect.midX - 6, y: rect.midY - 30)
        
        let result = CGPoint(x: round(radius * cos(Math.degreesToRadians(value: -angle)) + centerPoint.x),
                             y: round(radius * sin(Math.degreesToRadians(value: -angle)) + centerPoint.y))
        
        return result
    }
    
    static func curentAngle(with lastPoint: CGPoint, rect: CGRect, endAngle: CGFloat) -> CGFloat {
        
        let startPoint = CGPoint(x: rect.midX, y: 0)
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        let vA = CGPoint(x: startPoint.x - centerPoint.x, y: startPoint.x - centerPoint.y)
        let vB = CGPoint(x: lastPoint.x - centerPoint.x, y: lastPoint.y - centerPoint.y)
        let vALength = sqrt(Math.square(value: vA.x) + Math.square(value: vA.y))
        let vBLength = sqrt(Math.square(value: vB.x) + Math.square(value: vB.y))
        let cosAngle = (vA.x * vB.x + vA.y * vB.y) / (vALength * vBLength)
        
        let result = vB.x < 0 ? endAngle + 10 - Math.radiansToDegrees(value: acos(cosAngle)) : Math.radiansToDegrees(value: acos(cosAngle))
        print(result)
        return result
    }
}


