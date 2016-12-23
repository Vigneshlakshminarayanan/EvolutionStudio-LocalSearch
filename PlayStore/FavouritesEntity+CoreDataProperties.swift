//
//  FavouritesEntity+CoreDataProperties.swift
//  PlayStore
//
//  Created by Vignesh on 23/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavouritesEntity {

    @NSManaged var uniqueID: String?
    @NSManaged var title: String?
    @NSManaged var address: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var latitude: Double
    @NSManaged var longtitude: Double
    @NSManaged var timeStamp: NSDate?

}
