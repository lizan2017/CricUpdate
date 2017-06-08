//
//  PlayerInfo+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 6/8/17.
//
//

import Foundation
import CoreData


extension PlayerInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerInfo> {
        return NSFetchRequest<PlayerInfo>(entityName: "PlayerInfo");
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var character: String?

}
