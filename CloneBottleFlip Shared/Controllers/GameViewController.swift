//
//  GameViewController.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 17.07.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Present the scene
        if let skView = self.view as! SKView? {
            if let scene = MenuScene(fileNamed: "MenuScene") {
                scene.scaleMode = .resizeFill
                skView.presentScene(scene)
            }
            skView.ignoresSiblingOrder = true
        }
        
        
        
     
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
