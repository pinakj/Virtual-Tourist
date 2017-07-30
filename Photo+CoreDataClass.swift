//
//  Photo+CoreDataClass.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/28/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Photo)
public class Photo: NSManagedObject {
    
    var image: UIImage? {
        return UIImage(data:(photo!) as Data)
    }
    
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(photo:NSData,pin: Pin, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: context)!
        super.init(entity: entity, insertInto: context)
        self.photo = photo
        self.pin = pin

    }
}
