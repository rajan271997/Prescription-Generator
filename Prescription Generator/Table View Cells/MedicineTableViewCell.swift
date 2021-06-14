//
//  MedicineTableViewCell.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 13/06/21.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet var txtViewMedicine: UITextView!
    @IBOutlet var lblMedicineCompany: UILabel!
    @IBOutlet var lblMedicineType: UILabel!
    @IBOutlet var lblMedicineStrength: UILabel!
    
    // MARK: Class Members
    private var medicine : Medicine!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Setup Cells Methods
    func setupCell(medicine : Medicine) {
        self.medicine = medicine
        
        // Setup UI
        txtViewMedicine.text = medicine.name
        lblMedicineCompany.text = medicine.company
        lblMedicineType.text = medicine.type
        
        if (medicine.strength ?? "").elementsEqual("") {
            lblMedicineStrength.text = "Strength - N.A"
        } else {
            lblMedicineStrength.text = "Strength - \(medicine.strength ?? "N.A")"
        }
    }
    
    func setupPrescriptionCell(medicine : Medicine) {
        
        txtViewMedicine.text = medicine.name
        lblMedicineCompany.text = medicine.company
        lblMedicineType.text = medicine.type
        lblMedicineStrength.text = "x\(medicine.times)"
    }
    
}
