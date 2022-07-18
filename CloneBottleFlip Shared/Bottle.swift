//
//  Bottle.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 18.07.2022.
//

import Foundation

class Bottle {
    
    var Sprite: String?
    var Mass: NSNumber?
    var Restitution: NSNumber?
    var XScale: NSNumber?
    var YScale: NSNumber?
    var MinFlips: NSNumber?
    
    init(_ bottleDctionary: NSDictionary) {
        self.Sprite = bottleDctionary["Sprite"] as? String
        self.Mass = bottleDctionary["Mass"] as? NSNumber
        self.Restitution = bottleDctionary["Restitution"] as? NSNumber
        self.XScale = bottleDctionary["XScale"] as? NSNumber
        self.YScale = bottleDctionary["YScale"] as? NSNumber
        self.MinFlips = bottleDctionary["MinFlips"] as? NSNumber
    }
    
}
