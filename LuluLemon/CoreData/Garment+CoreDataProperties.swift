//
//  Garment+CoreDataProperties.swift
//  LuluLemon
//
//  Created by Ronald Jones on 11/19/22.
//
//

import Foundation
import CoreData
import UIKit

extension Garment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garment> {
        return NSFetchRequest<Garment>(entityName: "Garment")
    }

    @NSManaged public var title: String?
    @NSManaged public var dateCreated: Date?

}

extension Garment : Identifiable {

}
