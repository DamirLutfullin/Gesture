//
//  TickleGestureRecognizer.swift
//  Gesture
//
//  Created by Damir L on 10.06.2021.
//

import UIKit

class ​TickleGestureRecognizer: UIGestureRecognizer {
    
    private let requiredTickles = 2
    private let distanceForTickletGesture: CGFloat = 25
    
    enum TickletDirection {
        case right, left, unknow
    }
    
    private var tickleCount = 0
    private var tickleStartLocation: CGPoint = .zero
    private var latestDirection: TickletDirection = .unknow
    
    override func reset() {
        tickleCount = 0
        latestDirection = .unknow
        tickleStartLocation = .zero
        
        if state == .possible {
            state = .failed
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        tickleStartLocation = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        
        let tickleLocation = touch.location(in: view)
        let horiaontalDifference = tickleLocation.x - tickleStartLocation.x
        
        if abs(horiaontalDifference) < distanceForTickletGesture {
            return
        }
        
        let direction: TickletDirection
        
        if horiaontalDifference < 0 {
            direction = .left
        } else {
            direction = .right
        }
        
        if latestDirection == .unknow || (latestDirection == .left
                                            && direction == .right) ||
        (latestDirection == .right
            && direction == .left) {
            tickleStartLocation = tickleLocation
            latestDirection = direction
            tickleCount += 1
        }
        
        if state == .possible && tickleCount > requiredTickles {
            state = .ended
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        reset()
    }
}
