//
//  Pin+CoreDataProperties.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/28/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Pin {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Photo)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Photo)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
