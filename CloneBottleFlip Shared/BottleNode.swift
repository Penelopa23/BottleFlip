//
//  BottleNode.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 18.07.2022.
//

import SpriteKit

class BottleNode: SKSpriteNode {

    init(_ bottle: Bottle) {
        let texture = SKTexture(imageNamed: bottle.Sprite!)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: texture.size())
        self.xScale = CGFloat(bottle.XScale!.floatValue)
        self.yScale = CGFloat(bottle.YScale!.floatValue)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.25
        self.physicsBody?.mass = CGFloat(bottle.Mass!.doubleValue)
        self.physicsBody?.restitution = CGFloat(bottle.Restitution!.doubleValue)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
}
