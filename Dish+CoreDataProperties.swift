//
//  Dish+CoreDataProperties.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 30/06/25.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var dishDescription: String?
    @NSManaged public var image: String?

}

extension Dish : Identifiable {

}
