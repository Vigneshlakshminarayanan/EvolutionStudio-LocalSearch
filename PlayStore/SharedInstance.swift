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
   
    var currentLocationLatValue = Double()
    var currentLocationLongValue = Double()
    var selectedEvent = NSString()
    var selectedVerticalLati = Double()
    var selectedVerticalLongi = Double()
    var isFromIndexing = Bool()
    var selectedVerticalUniqueIDFromIndexing = NSString()
    
    override init() {
        print("Singleton Created")
    }
    
    func currentLocationLatValue(lat:Double)->Void{
        currentLocationLatValue = lat
    }
    
    func currentLocationLongiValue(longVal:Double)->Void{
        currentLocationLongValue = longVal
    }
    
    func selectedEvent(category:NSString) -> Void {
        selectedEvent = category as String
    }
    
    func setSelectedVerticalsLocation(lat:Double,long:Double) -> Void {
        selectedVerticalLati = lat
        selectedVerticalLongi = long
    }
    
    func cameFromHomeScreen(bool:Bool){
        isFromIndexing = bool
    }
    
    func setSelectedVerticalUniqueID(uniqID:NSString) -> Void {
        selectedVerticalUniqueIDFromIndexing = uniqID as String
    }

}
