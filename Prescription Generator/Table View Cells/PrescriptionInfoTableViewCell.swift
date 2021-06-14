//
//  PrescriptionInfoTableViewCell.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 14/06/21.
//

import UIKit

class PrescriptionInfoTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet var lblPrescription: UILabel!
    @IBOutlet var lblPatient: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Setup Cell Method
    func setupCell(prescription : Prescription) {
        lblPrescription.text = prescription.name
        lblPatient.text = prescription.patientName
    }
    
}
