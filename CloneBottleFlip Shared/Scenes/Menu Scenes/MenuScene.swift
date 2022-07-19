//
//  MenuScene.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 17.07.2022.
//

import SpriteKit

class MenuScene: SimpleScene {
    
    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNode = SKSpriteNode()
    var unlockLabelNode = SKLabelNode()
    
    var highScore = 0;
    var totalFlips = 0;
    var bottles = [Bottle]()
    var selectedBottleIndex = 0
    var totalBottles = 0;
    var isShopButton = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        //Loading bottles from items.plist
        bottles = BottleController.readItems()
        totalBottles = bottles.count
        
        //Get total flips
        highScore = UserDefaults.standard.integer(forKey: "localHighscore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")
        
        setupUI()
    }
    
    func setupUI() {
        
        //Logo Node
        let logo = ButtonNode(imageNode: "logo", position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 75), xScale: 1, yScale: 1)
        self.addChild(logo)
        
        //Best Score Label
        let bestScoreLabelNode = LabelNode(text: "Best Score", fontSize: 15, position: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 165), fontColor: UIColor.red)
        
        self.addChild(bestScoreLabelNode)
        
        //High Score Label
        let highScoreLabelNode = LabelNode(text: String(highScore), fontSize: 40, position: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 200), fontColor: UIColor.red)
        
        self.addChild(highScoreLabelNode)
        
        //Total flips Label
        let totalFlipsLabelNode = LabelNode(text: "Amount Flips", fontSize: 15, position: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 165), fontColor: UIColor.blue)
        
        self.addChild(totalFlipsLabelNode)
        
        //Total Flips Score Label
        let flipsLabelNode = LabelNode(text: String(totalFlips), fontSize: 40, position: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 200), fontColor: UIColor.blue)
        
        self.addChild(flipsLabelNode)
        
        //Play Button
        playButtonNode = ButtonNode(imageNode: "play_button", position: CGPoint(x: self.frame.midX, y: self.frame.midY - 15), xScale: 0.9, yScale: 0.9)
        
        self.addChild(playButtonNode)
        
        //Table node
        tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY + 29), xScale: 2.3, yScale: 2.3)
        tableNode.zPosition = 3
        
        self.addChild(tableNode)
        
        //Bottle Node
        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]
        
        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.zPosition = 10
        
        self.addChild(bottleNode)
        
        //Left Button
        leftButtonNode = ButtonNode(imageNode: "left_button", position: CGPoint(x: self.frame.midX + leftButtonNode.size.width - 130, y: self.frame.minY - leftButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(leftButtonNode, state: true)
        self.addChild(leftButtonNode)
        
        //Right Button
        rightButtonNode = ButtonNode(imageNode: "right_button", position: CGPoint(x: self.frame.midX - rightButtonNode.size.width + 130, y: self.frame.minY + rightButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
        //Lock node
        flipsTagNode = ButtonNode(imageNode: "lock", position: CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94), xScale: 0.5, yScale: 0.5)
        flipsTagNode.zPosition = 25
        flipsTagNode.zRotation = 0.3
        self.addChild(flipsTagNode)
        
        //Unlock label
        unlockLabelNode = LabelNode(text: "0", fontSize: 26, position: CGPoint(x: 0, y: -unlockLabelNode.frame.size.height + 25), fontColor: UIColor.white)
        
        unlockLabelNode.zPosition = 30
        flipsTagNode.addChild(unlockLabelNode)
        
        //Update selected bottle
        self.updateSelectedBottle(selectedBottle)
        
        self.pulseLockNode(flipsTagNode)
    }
    
    func changeButton(_ buttonNode: SKSpriteNode, state: Bool) {
        //Change arrow sprites
        if state {
            buttonNode.color = UIColor.gray
            buttonNode.colorBlendFactor = 1
        }
    }
    
    func updateSelectedBottle(_ bottle: Bottle) {
        
        //Update to the selected bootle
        let unlockFlips = bottle.MinFlips!.intValue - highScore
        let unlocked = (unlockFlips <= 0)
        
        flipsTagNode.isHidden = unlocked
        unlockLabelNode.isHidden = unlocked
        
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "play_button" : "shop_button"))
        
        isShopButton = !unlocked
        
        bottleNode.size = CGSize(width: bottleNode.texture!.size().width * CGFloat(bottle.XScale!.floatValue), height: bottleNode.texture!.size().height * CGFloat(bottle.YScale!.floatValue))
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 94)
        
        flipsTagNode.position = CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94)
        unlockLabelNode.text = "\(bottle.MinFlips!.intValue)"
        unlockLabelNode.position = CGPoint(x: 0, y: -unlockLabelNode.frame.size.height + 25)
        self.updateArrowsState()
    }
    
    func updateArrowsState() {
        //Update arrows states
        self.changeButton(leftButtonNode, state: Bool(selectedBottleIndex as NSNumber))
        self.changeButton(rightButtonNode, state: selectedBottleIndex != totalBottles - 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            //Play button is pressed
            if playButtonNode.contains(location){
                self.startGame()
            }
            //Left button
            if leftButtonNode.contains(location) {
                let prevIndex = selectedBottleIndex - 1
                if prevIndex >= 0 {
                    self.updateByIndex(prevIndex)
                }
            }
            
            if rightButtonNode.contains(location) {
                let nextIndex = selectedBottleIndex + 1
                if nextIndex < totalBottles {
                    self.updateByIndex(nextIndex)
                }
            }
        }
    }
    
    func updateByIndex(_ index: Int){
        //Update base index
        let bottle = bottles[index]
        
        selectedBottleIndex = index
        
        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(index)
    }
    
    func pulseLockNode(_ node:SKSpriteNode) {
        //Pulse animation for lock
        let scaleDownAction = SKAction.scale(to: 0.35, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 0.5, duration: 0.5)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        node.run(SKAction.repeatForever(seq))
    }
    
    func startGame() {
        //NotShopButton, so start game
        if !isShopButton {
            let userData = ["bottle" : bottles[selectedBottleIndex]] as NSMutableDictionary
            //TO DO
            self.changeToSceneBy(nameScene: "GameScene", userData: userData)
        }else{
            //Start inAppPurchaise
            print("Start iAP")
        }
    }
}
