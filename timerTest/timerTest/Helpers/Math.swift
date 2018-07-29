//
//  Math.swift
//  timerTest
//
//  Created by Taras on 27/07/2018.
//  Copyright © 2018 Taras. All rights reserved.
//

import Foundation
import UIKit

class Math {
    
    static func degreesToRadians (value: CGFloat) -> CGFloat {
        return value * CGFloat.pi / 180.0
    }
    
    static func radiansToDegrees (value: CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat.pi
    }
    
    static func square (value: CGFloat) -> CGFloat {
        return value * value
    }
}
