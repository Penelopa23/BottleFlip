//
//  GameScene.swift
//  CloneBottleFlip Shared
//
//  Created by Артём Витинский on 17.07.2022.
//

import SpriteKit

class GameScene: SimpleScene {
    
    var scoreLabelNode = SKLabelNode()
    var highscoreLaabelNode = SKLabelNode()
    var backButtonNOde = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    
    var didSwipe = false

    
  

    override func didMove(to view: SKView) {
        //Setting the scene
        self.physicsBody?.restitution = 0
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        self.setupUINodes()
        self.setupGameNodes()
    }
    
    func setupUINodes() {
        //Score label node
        scoreLabelNode = LabelNode(text: "0", fontSize: 80, position: CGPoint(x: self.frame.midX, y: self.frame.midY), fontColor: UIColor.green)
        scoreLabelNode.zPosition = -1
        self.addChild(scoreLabelNode)
        
        //High score label node
        highscoreLaabelNode = LabelNode(text: "New Result", fontSize: 32, position: CGPoint(x: self.frame.midX, y: self.frame.midY - 40), fontColor: UIColor.green)
        highscoreLaabelNode.zPosition = -1
        self.addChild(highscoreLaabelNode)
        
        //Back button node
        backButtonNOde = ButtonNode(imageNode: "back_button", position: CGPoint(x: self.frame.minX + backButtonNOde.size.width + 30, y: self.frame.maxY - backButtonNOde.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(backButtonNOde)
        
        //Reset button
        resetButtonNode = ButtonNode(imageNode: "reset_button", position: CGPoint(x: self.frame.maxX - resetButtonNode.size.width - 40, y: self.frame.maxY - resetButtonNode.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(resetButtonNode)
        
        //Tutorial button
       // let tutorialFinished = UserDefaults.standard.bool(forKey: "tutorialFinished")
        //tutorialNode = ButtonNode(imageNode: "tutorial", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 0.65, yScale: 0.65)
       // tutorialNode.zPosition = 5
        //tutorialNode.isHidden = tutorialFinished
        //self.addChild(tutorialNode)
    }
    
    func setupGameNodes() {
        
        //Table node
        let tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY + 29), xScale: 1.8, yScale: 1.8)
        tableNode.zPosition = 3
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        //let tableNode = SKSpriteNode(fileNamed: "table")
        //tableNode?.physicsBody = SKPhysicsBody(rectangleOf: (tableNode!.texture?.size())!)
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.45
        tableNode.yScale = 0.45
        tableNode.position = CGPoint(x: self.frame.midX, y: 29)
        //self.addChild(tableNode)
       
        
        self.addChild(tableNode)
        
        //Button Node
        let selectedBottle = self.userData?.object(forKey: "bottle")
        bottleNode = BottleNode(selectedBottle as! Bottle)
        self.addChild(bottleNode)
        
        
    }
   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if backButtonNOde.contains(location) {
                self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
            
            if resetButtonNode.contains(location) {
                failedFlip()
            }
            if tutorialNode.contains(location) {
                tutorialNode.isHidden = true
                UserDefaults.standard.set(true, forKey: "tutorialFinished")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func failedFlip() {
        //Failed flip, reset score and bottle
        self.resetBottle()
    }
    
    func resetBottle() {
        //Reset bottle after failed or successful flip
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height)
        bottleNode.physicsBody?.angularVelocity = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
    }
}

