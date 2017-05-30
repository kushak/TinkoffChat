//
//  Emitter.swift
//  TinkoffChat
//
//  Created by user on 30.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class Emitter: NSObject {
    
    let emitter = CAEmitterLayer()
    let view: UIView
    var point: CGPoint?
    
    init(view: UIView) {
        self.view = view
        super.init()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapAction))
        tap.minimumPressDuration = 1
        self.view.addGestureRecognizer(tap)
        
    }
    
    func tapAction(gesture: UITapGestureRecognizer) {
        point = gesture.location(in: view)
        if gesture.state == .began {
            createFireWorks()
        } else if gesture.state == .ended {
            print("ended")
            stopFireWorks()
        } else if gesture.state == .changed {
            createFireWorks()
        }
    }
    
    func createFireWorks() {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let emitterCell = CAEmitterCell()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerCircle
        emitter.emitterPosition = point!
        
        emitter.emitterSize = rect.size
        emitterCell.contents = UIImage(named: "tinkof_icon")?.cgImage
        emitterCell.birthRate = 5
        emitterCell.lifetime = 2.5
        
        emitterCell.velocity = 20.0
        
        emitterCell.emissionLongitude = 0.3
        emitterCell.emissionRange = 0.3
        
        emitter.emitterCells = [emitterCell]
    }
    
    func stopFireWorks() {
        emitter.removeFromSuperlayer()
    }

}
