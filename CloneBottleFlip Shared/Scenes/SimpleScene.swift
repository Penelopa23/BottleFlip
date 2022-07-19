//
//  SimpleScene.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 18.07.2022.
//

import SpriteKit

class SimpleScene: SKScene {
    
    func changeToSceneBy(nameScene: String, userData: NSMutableDictionary) {
        //Change to scene
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        let transition  = SKTransition.fade(with: UI_BACKGROUND_COLOR, duration: 0.3)
        
        scene.scaleMode = .aspectFill
        scene.userData = userData
        self.view?.presentScene(scene, transition: transition)
    }
    
    func playSoundFX(_ action: SKAction) {
        self.run(action)
    }
}
