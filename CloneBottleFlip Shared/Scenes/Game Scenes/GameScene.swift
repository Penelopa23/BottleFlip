//
//  GameScene.swift
//  CloneBottleFlip Shared
//
//  Created by Артём Витинский on 17.07.2022.
//

import SpriteKit

class GameScene: SimpleScene {
    
    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    var backButtonNOde = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    var currentScore = 0

    var popSound = SKAction()
    var failSound = SKAction()
    var winSound = SKAction()
    var numberOfTaps = 0
    var resetScore = 0;
  

    override func didMove(to view: SKView) {
        //Setting the scene
        self.physicsBody?.restitution = 0
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed(GAME_SOUND_WIN, waitForCompletion: false)
        
        
        self.setupUINodes()
        self.setupGameNodes()
    }
    
    func setupUINodes() {
        //Score label node
        scoreLabelNode = LabelNode(text: "0", fontSize: 80, position: CGPoint(x: self.frame.midX, y: self.frame.midY), fontColor: UIColor.green)
        scoreLabelNode.zPosition = -1
        self.addChild(scoreLabelNode)
        
        //High score label node
        highscoreLabelNode = LabelNode(text: "New Result", fontSize: 32, position: CGPoint(x: self.frame.midX, y: self.frame.midY - 40), fontColor: UIColor.green)
        highscoreLabelNode.isHidden = true
        highscoreLabelNode.zPosition = -1
        self.addChild(highscoreLabelNode)
        
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
        tableNode = SKSpriteNode(imageNamed: "table")
        //tableNode.zPosition = 3
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        //let tableNode = SKSpriteNode(fileNamed: "table")
        //tableNode?.physicsBody = SKPhysicsBody(rectangleOf: (tableNode!.texture?.size())!)
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 2.3
        tableNode.yScale = 2.3
        tableNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 29)
        //self.addChild(tableNode)
       
        
        self.addChild(tableNode)
        
        //Button Node
        let selectedBottle = self.userData?.object(forKey: "bottle")
        bottleNode = BottleNode(selectedBottle as! Bottle)
        self.addChild(bottleNode)
        
        self.resetBottle()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Touch recording touches
        if touches.count > 1 {
            return
        }
        
        
    
        let touch = touches.first
        let location = touch!.location(in: self) //Xstart
        
        start = location
        startTime = touch!.timestamp
        
        //resetScore
        if tableNode.contains(location) {
            resetScore += 1
            if resetScore > 5 {
                UserDefaults.standard.set(0, forKey: "localHighscore")
                UserDefaults.standard.set(0, forKey: "flips")
                UserDefaults.standard.synchronize()
                resetScore = 0
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNOde.contains(location){
                self.playSoundFX(popSound)
                self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
            
            if resetButtonNode.contains(location) {
                self.playSoundFX(popSound)
                failedFlip()
            }
            if tutorialNode.contains(location) {
                tutorialNode.isHidden = true
                UserDefaults.standard.set(true, forKey: "tutorialFinished")
                UserDefaults.standard.synchronize()
            }
            
            
        }
        
       
        
        //Bottle fliping logic
        if !didSwipe {
            //Speed = distance/time
            //Distance = sqrt(x * x) + (y*y)
            //X/Y = Xend - Xstart
            let touch = touches.first
            let location = touch?.location(in: self) //Xend
            
            let x = ceil(location!.x - start.x)
            let y = ceil(location!.y - start.y)
            
            let distance = sqrt(x*x + y*y)
            
            let time = CGFloat(touch!.timestamp - startTime)
            
            if (distance >= GAME_SWIPE_MIN_DISTANCE && y > 0) {
                let speed = distance/time
                if speed >= GAME_SWIPE_MIN_SPEED {
                    //Add angular velocity impuls
                    bottleNode.physicsBody?.angularVelocity = speed/100
                    bottleNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distance + GAME_DISTACE_MULTIPLIER))
                    didSwipe = true
                }
            }
        }
    }
    
 
    
    func failedFlip() {
        //Failed flip, reset score and bottle
        currentScore = 0
        self.playSoundFX(failSound)
        self.updateScore()
        self.resetBottle()
    }
    
    func resetBottle() {
        //Reset bottle after failed or successful flip
        self.playSoundFX(popSound)
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 94)
        bottleNode.physicsBody!.angularVelocity = 0
        bottleNode.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.checkIfSuccessfulFlip()
    }
    
    func checkIfSuccessfulFlip() {
        if (bottleNode.position.x <= 0 || bottleNode.position.x >= self.frame.size.width || bottleNode.position.y <= 0) {
            self.failedFlip()
        }
        
        if (didSwipe == true && bottleNode.physicsBody!.isResting) {
            let bottleRotation = abs(bottleNode.zRotation)
            
            if bottleRotation > 0 && bottleRotation < 0.05 {
                self.successFlip()
            }else{
                self.failedFlip()
            }
        }
    }
    
    func successFlip() {
        //Success fliped, so update scores and reset bottle
        currentScore += 1
        self.playSoundFX(winSound)
        self.updateFlips()
        self.updateScore()
        self.resetBottle()
    }
    
    func updateScore() {
        //Updating score based on flips and saving highscore
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighscore = UserDefaults.standard.integer(forKey: "localHighscore")
        if currentScore > localHighscore {
            highscoreLabelNode.isHidden = false
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 5.0)
            
            highscoreLabelNode.run(fadeAction, completion: {
                self.highscoreLabelNode.isHidden = true
            })
            
            UserDefaults.standard.set(currentScore, forKey: "localHighscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateFlips() {
        //Update total flips
        var flips = UserDefaults.standard.integer(forKey: "flips")
        
        flips += 1
        UserDefaults.standard.set(flips, forKey: "flips")
        UserDefaults.standard.synchronize()
    }
}
