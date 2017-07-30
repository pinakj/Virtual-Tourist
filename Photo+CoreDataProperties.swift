//
//  Photo+CoreDataProperties.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/28/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var pin: Pin?

}
