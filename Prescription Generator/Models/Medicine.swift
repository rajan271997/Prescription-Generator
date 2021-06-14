//
//  Medicine.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import Foundation

// MARK: - MedicineElement
struct MedicineElement: Codable {
    let id: Int
    let name, type, company, strength,strengthtype: String
}

typealias MedicineInfo = [MedicineElement]
