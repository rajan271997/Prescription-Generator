//
//  Medicine+CoreDataProperties.swift
//  
//
//  Created by Rajan Arora on 14/06/21.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var company: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var strength: String?
    @NSManaged public var strengthType: String?
    @NSManaged public var times: Int64
    @NSManaged public var type: String?
    @NSManaged public var toPrescription: Prescription?

}
