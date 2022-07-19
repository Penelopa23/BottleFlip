//
//  LabelNode.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 17.07.2022.
//

import UIKit
import SpriteKit

class LabelNode: SKLabelNode {
    convenience init(text: String, fontSize: CGFloat, position: CGPoint, fontColor: UIColor) {
        self.init(fontNamed: UI_FONT)
        self.text = text
        self.fontSize = fontSize
        self.position = position
        self.fontColor = fontColor
    }
}
