//
//  BottleController.swift
//  CloneBottleFlip iOS
//
//  Created by Артём Витинский on 18.07.2022.
//

import Foundation

class BottleController {
    
    class func readItems() -> [Bottle] {
        
        var bottles = [Bottle]()
        //Reading items from plist
        if let path = Bundle.main.path(forResource: "items", ofType: "plist"), let plistArray = NSArray(contentsOfFile: path) as? [[String: Any]] {
            for dic in plistArray {
                let bottle = Bottle(dic as NSDictionary)
                bottles.append(bottle)
            }
        }
        
        return bottles
    }
    
    class func saveSelectedBottle(_ index: Int) {
        //Save index
        UserDefaults.standard.set(index, forKey: "selectedBottle")
        UserDefaults.standard.synchronize()
    }
    
    class func getSaveBottleIndex() -> Int {
        //Get saved index
        return UserDefaults.standard.integer(forKey: "selectedBottle")
    }
}
