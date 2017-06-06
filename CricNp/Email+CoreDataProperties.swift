//
//  Email+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 6/3/17.
//
//

import Foundation
import CoreData


extension Email {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Email> {
        return NSFetchRequest<Email>(entityName: "Email");
    }

    @NSManaged public var email: String?

}
