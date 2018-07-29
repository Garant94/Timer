//
//  Drawer.swift
//  timerTest
//
//  Created by Taras on 28/07/2018.
//  Copyright © 2018 Taras. All rights reserved.
//

import Foundation
import UIKit

class Drawer {
    
    let lineWidth: CGFloat = 50
    
    let radius: CGFloat
    
    let rect: CGRect
    
    let startAngle: CGFloat
    
    let endAngle: CGFloat
    
    let angleOffset: CGFloat = 90
    
    private var centerPoint: CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    private(set) var angle: CGFloat = -30
    
    private let markerOffset: CGFloat = 20
    
    private let markerWidth: CGFloat = 5
    
    init(radius: CGFloat, rect: CGRect, startAngle: CGFloat, endAngle: CGFloat) {
        self.radius = radius
        self.rect = rect
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    func  setAngle(angle: CGFloat) {
        self.angle = angle
    }
    
    func drawBackgroundCircle(ctx: CGContext) {
        
        ctx.addArc(center: centerPoint, radius: radius,
                   startAngle: Math.degreesToRadians(value: startAngle + angleOffset),
                   endAngle: Math.degreesToRadians(value: endAngle + angleOffset), clockwise: false)
        
        ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.5).cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.setLineCap(.butt)
        ctx.drawPath(using: .stroke)
    }
    
    func drawTrackCircle(ctx: CGContext, bounds: CGRect) {
        
        UIGraphicsBeginImageContext(CGSize(width: rect.size.width, height:rect.size.height))
        
        guard let trackCtx = UIGraphicsGetCurrentContext() else { return }
        
        trackCtx.addArc(center: centerPoint, radius: radius,
                        startAngle: Math.degreesToRadians(value: startAngle + angleOffset),
                        endAngle: Math.degreesToRadians(value: angle + angleOffset + 1), clockwise: true)
        
        UIColor.red.set()
        
        trackCtx.setShadow(offset: CGSize(width: 0, height: 0), blur: self.angle/15, color: UIColor.black.cgColor)
        
        trackCtx.setLineWidth(lineWidth)
        trackCtx.drawPath(using: .stroke)
        
        let  mask = UIGraphicsGetCurrentContext()!.makeImage()
        UIGraphicsEndImageContext()
        
        ctx.saveGState()
        ctx.clip(to: bounds, mask: mask!)
        
        
        ctx.addArc(center: centerPoint, radius: radius,
                   startAngle: Math.degreesToRadians(value: startAngle + angleOffset),
                   endAngle: Math.degreesToRadians(value: endAngle + angleOffset), clockwise: false)
        
        ctx.setStrokeColor(UIColor.timerOrangeColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.drawPath(using: .stroke)
        
        ctx.restoreGState()
    }
    
    func addMarkers(ctx: CGContext, markerColor: UIColor) {
        for i in 1...12 {
            ctx.saveGState()
            ctx.translateBy(x: rect.midX, y: rect.midY)
            let defaultDegree = 30
            ctx.rotate(by: Math.degreesToRadians(value: CGFloat(i * defaultDegree)))
            
            drawMarker(ctx: ctx, x: radius - markerOffset, y: 0, color: markerColor)
            
            ctx.restoreGState()
        }
    }
    
    private func drawMarker(ctx: CGContext, x: CGFloat, y: CGFloat, color: UIColor) {
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: radius + markerOffset, y: 0))
        path.addLine(to: CGPoint(x: x, y: y))
        path.closeSubpath()
        
        ctx.addPath(path)
        ctx.setLineWidth(markerWidth)
        ctx.setStrokeColor(color.cgColor)
        ctx.strokePath()
        
    }
    
    func drawSlider(ctx: CGContext, status: TimerStatus) {
        
        guard status == .stopped else { return }
        
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: Math.degreesToRadians(value: CGFloat(endAngle - (angle + angleOffset))))

        let path = CGMutablePath()
        path.move(to: CGPoint(x: radius + 30, y: 0))
        path.addLine(to: CGPoint(x: radius - 30, y: 0))
        path.closeSubpath()

        ctx.addPath(path)
        ctx.setLineWidth((markerWidth + 1) * 2)
        ctx.setStrokeColor(UIColor.timerOrangeColor.cgColor)
        ctx.strokePath()
        ctx.restoreGState()
    }
    
}
