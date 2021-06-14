//
//  AddMedicineViewController.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 13/06/21.
//

import UIKit

class AddMedicineViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var lblDoze: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var lblMedicineName: UILabel!
    
    
    // MARK: Class Members
    var dozes : ((Int) -> Void)?
    var name : String?
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.stepper.value = 1.0
        self.lblDoze.text = "1"
        lblMedicineName.text = name
    }
    
    // MARK: Actions
    @IBAction func cancelPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        dozes?(Int(stepper.value))
        self.view.removeFromSuperview()
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        self.lblDoze.text = "\(Int(stepper.value))"
    }
    

}
