//
//  ToyScene.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-14.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import SpriteKit

let heartHeight: CGFloat = 18.0
let heartsFile = "heart-bubbles.sks"

class ToyScene : SKScene {
    var emitter: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill // make scene's size == view's size
        backgroundColor = UIColor.clear
    }
    
    func beginBubbling() {
        if let e = emitter {
            e.resetSimulation()
        } else {
            guard let emitter = SKEmitterNode(fileNamed: heartsFile) else {
                return
            }
            
            let x = floor(size.width / 2.0)
            let y = heartHeight
            emitter.position = CGPoint(x: x, y: y)
            emitter.name = "heart-bubbles"
            emitter.targetNode = self
            
            addChild(emitter)
        }
    }
}
