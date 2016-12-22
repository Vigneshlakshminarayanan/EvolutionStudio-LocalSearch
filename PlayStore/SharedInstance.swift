//
//  SharedInstance.swift
//  PlayStore
//
//  Created by Vignesh on 22/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//

import UIKit

class SharedInstance: NSObject {

    static let sharedInstance = SharedInstance()
    var latitudeValue = Double()
    var longiValue = Double()
    var cateogorySelected = NSString()

    override init() {
        print("Singleton Created")
    }
    
    func setLatValue(lat:Double)->Void{
        latitudeValue = lat
    }
    
    func setLongValue(longVal:Double)->Void{
        longiValue = longVal
    }
    
    func setSelectedCategory(category:NSString) -> Void {
        cateogorySelected = category as String
    }

}
