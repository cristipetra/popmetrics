//
//  LocalUser+CoreDataProperties.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//


import Foundation
import CoreData

extension LocalUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        return NSFetchRequest<LocalUser>(entityName: "LocalUser");
    }

    @NSManaged public var authToken: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?

}
