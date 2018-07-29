//
//  CircleSliderViewController.swift
//  timerTest
//
//  Created by Taras on 23/07/2018.
//  Copyright © 2018 Taras. All rights reserved.
//

import UIKit

class CircleSliderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newView = CircleTimer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(newView)
    }
}
