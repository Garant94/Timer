//
//  Circle.swift
//  timerTest
//
//  Created by Taras on 26/07/2018.
//  Copyright © 2018 Taras. All rights reserved.
//

import UIKit

enum TimerStatus {
    case started
    case stopped
}

class CircleTimer: UIControl {

    var timeLabel: UILabel!
    var startButton: UIButton!
    
    private var radius: CGFloat
    
    private var tempAngle:CGFloat = 0
    private var lastAngleBeforeStart: CGFloat = 0
    
    private var seconds: Int = 1
    private var timer: Timer?
    
    private let drawer: Drawer
    
    var timerStatus: TimerStatus = .started {
        
        didSet {
            switch timerStatus {
            case .started:
                backgroundColor = UIColor.timerDarkBlueColor
                configureButton(with: "Stop", color: UIColor.timerRedColor)
                
            default:
                backgroundColor = UIColor.timerRedColor
                configureButton(with: "Start", color: UIColor.timerOrangeColor)
            }
        }
    }
    
    override init(frame: CGRect) {
        
        radius = frame.width / 2.5
        drawer = Drawer(radius: radius, rect: frame, startAngle: 0, endAngle: 360)
        
        super.init(frame: frame)
        
        createLabels()
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func draw(_ rect: CGRect) {
        
        guard let ctx  = UIGraphicsGetCurrentContext() else { return }
        
        drawer.drawBackgroundCircle(ctx: ctx)
        drawer.drawTrackCircle(ctx: ctx, bounds: self.bounds)
        drawer.drawSlider(ctx: ctx, status: timerStatus)
        drawer.addMarkers(ctx: ctx, markerColor: backgroundColor ?? UIColor.timerRedColor)
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let lastPoint = touch.location(in: self)
        
        if timerStatus == .stopped {
            self.moveSlider(to: lastPoint)
        }

        return true
    }
    
    private func formatTimerWith(seconds: Int, miliseconds: Int) -> String {
        
        return String(format: "%02i:%02i", seconds, miliseconds)
    }
    
    
    // MARK: init views
    
    private func createLabels() {
        
        let halfSide = radius - drawer.lineWidth * 1.5
        let labelX = frame.midX - halfSide
        let labelY = frame.midY - halfSide
        timeLabel = UILabel(frame: CGRect(x: labelX, y: labelY, width: 2 * halfSide, height: 2 * halfSide))
        
        timeLabel.textColor = .white
        
        timeLabel.textAlignment = .center
        timeLabel.text = formatTimerWith(seconds: seconds, miliseconds: 0)
        timeLabel.font = UIFont.boldSystemFont(ofSize: 60)
        self.addSubview(timeLabel)
        
        
        let secLabel = UILabel(frame: CGRect(x: timeLabel.frame.maxX - 10, y: timeLabel.frame.midY, width: 50, height: 30))
        secLabel.textColor = .white
        
        secLabel.textAlignment = .center
        secLabel.text = "sec"
        secLabel.font = UIFont.systemFont(ofSize: 19)
        self.addSubview(secLabel)

    }
    
    private func setUpButton() {
        startButton = UIButton(frame: CGRect(x: frame.minX + 20, y: frame.maxY - 70, width: frame.width - 40, height: 60))
        timerStatus = .stopped
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        addSubview(startButton)
    }
    
    private func configureButton(with title: String, color: UIColor) {
        startButton.setTitle(title, for: .normal)
        startButton.backgroundColor = color
    }    
    
    
    //MARK: Move slider
    
    private func moveSlider(to point: CGPoint) {
        
        let currentAngle: CGFloat = CircleTimerHelper.curentAngle(with: point, rect: frame, endAngle: drawer.endAngle)
        moveTrackTo(currentAngle: currentAngle)
    }
    
    private func moveTrackTo(currentAngle: CGFloat) {
        
        var miliseconds = 0
        var angle: CGFloat = 0
        
        if timerStatus == .started {
            let fullMiliseconds = Int(currentAngle * 10 / 3)
            seconds = fullMiliseconds / 100
            miliseconds = fullMiliseconds % 100
            angle = drawer.endAngle - floor(currentAngle)
            
        } else {
            seconds = Int(currentAngle / 30)
            angle = drawer.endAngle - CGFloat(seconds) * 30
        }
        
        drawer.setAngle(angle: angle)
        timeLabel.text = formatTimerWith(seconds: seconds, miliseconds: miliseconds)
        setNeedsDisplay()
    }
    
    
    // MARK: click button action
    
    @objc private func startButtonClicked() {
        timerStatus == .started ? stopTimer() : startTimer()
    }
    
    
    // MARK: timer
    
    @objc private func animateTrackWhenCounting() {
        tempAngle -= 1
        tempAngle >= drawer.startAngle ? moveTrackTo(currentAngle: tempAngle) : stopTimer()
    }
    
    private func startTimer() {
        tempAngle = drawer.angle >= 0 ? drawer.endAngle - drawer.angle : abs(drawer.angle)
        lastAngleBeforeStart = tempAngle
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(animateTrackWhenCounting), userInfo: nil, repeats: true)
        timerStatus = .started
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerStatus = .stopped
        moveTrackTo(currentAngle: lastAngleBeforeStart)
        tempAngle = 0
        lastAngleBeforeStart = 0
    }
   
}
