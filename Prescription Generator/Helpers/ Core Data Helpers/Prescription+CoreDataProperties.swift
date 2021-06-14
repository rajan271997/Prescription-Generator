//
//  Prescription+CoreDataProperties.swift
//  
//
//  Created by Rajan Arora on 14/06/21.
//
//

import Foundation
import CoreData


extension Prescription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prescription> {
        return NSFetchRequest<Prescription>(entityName: "Prescription")
    }

    @NSManaged public var name: String?
    @NSManaged public var patientName: String?
    @NSManaged public var rawMedicines: Set<Medicine>?

}

// MARK: Generated accessors for rawMedicines
extension Prescription {

    @objc(addRawMedicinesObject:)
    @NSManaged public func addToRawMedicines(_ value: Medicine)

    @objc(removeRawMedicinesObject:)
    @NSManaged public func removeFromRawMedicines(_ value: Medicine)

    @objc(addRawMedicines:)
    @NSManaged public func addToRawMedicines(_ values: Set<Medicine>)

    @objc(removeRawMedicines:)
    @NSManaged public func removeFromRawMedicines(_ values: Set<Medicine>)

}
