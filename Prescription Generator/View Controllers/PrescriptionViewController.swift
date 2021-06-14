//
//  PrescriptionViewController.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 13/06/21.
//

import UIKit

class PrescriptionViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSavePrescription: UIButton!
    @IBOutlet var txtFieldPatient: UITextField! {
        didSet {
            let doneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(donePressed))
            txtFieldPatient.addToolbar(leading: [], trailing: [doneButton])
        }
    }
    @IBOutlet var txtFieldDays: UITextField! {
        didSet {
            let doneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(donePressed))
            txtFieldDays.addToolbar(leading: [], trailing: [doneButton])
        }
    }
    
    // MARK: Class Members
    var medicines = [Medicine]()
    var prescription : Prescription?
    var resetState : (()-> Void)?
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (prescription != nil) {
            txtFieldPatient.text = prescription?.patientName
            self.btnSavePrescription.isHidden = true
        }
    }
    
    
    // MARK: Helper Methods
    func registerNibs() {
        tableView.register(UINib(nibName: "MedicineTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicineTableViewCell")
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 250.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero) // Hide extra rows
    }
    
    func delete(row : Int) {
        self.medicines.remove(at: row)
        self.tableView.reloadData()
        checkData()
    }
    
    func checkData() {
        if (self.medicines.count <= 0) {
            Helper.instance.showAlert(controller: self, title: "Alert", message: "Please add medicines to generate prescription.", style: .alert, cancelButtonVisible: false) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkPreConditions() -> Bool {
        var message : String?
        
        if (txtFieldPatient.text ?? "").elementsEqual("") {
            message = "Please enter a Patient Name"
        } else if (txtFieldDays.text ?? "").elementsEqual(""){
            message = "Please enter the days"
        }
        
        if (message != nil) {
            Helper.instance.showAlert(controller: self, title: "Alert", message: message!, style: .alert, cancelButtonVisible: false, action: nil)
            return false
        }
        
        return true
    }
    
    func savePrescription(name : String) {
        let setsOfMedicines = Set(medicines)
        CoreDataHelper.instance.addPrescription(name: name,patientName: txtFieldPatient.text, medicines: setsOfMedicines)
    }
    
    // MARK: Actions
    @IBAction func share(_ sender: Any) {
        if (checkPreConditions()) {
            Helper.instance.sharePrescription(patientName: txtFieldPatient.text ?? "", days: "\(txtFieldDays.text ?? "")", medicines: medicines, controller: self)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePresription(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to save prescription ?", preferredStyle: .alert)
        Helper.instance.addTextFieldToAlert(alert: alert, placeHolder: "Enter Prescription name")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            var message : String
            if !(textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).elementsEqual("") {
                message = "Saved Successfully."
                self.btnSavePrescription.isHidden = true
                self.resetState?()
                self.savePrescription(name: textField.text!)
            } else {
                message = "Please enter a name to save prescription."
            }
            Helper.instance.showAlert(controller: self, title: "Alert", message: message, style: .alert, cancelButtonVisible: false, action: nil)
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UITableView Methods
extension PrescriptionViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineTableViewCell", for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        let medicine = medicines[indexPath.row]
        cell.setupPrescriptionCell(medicine: medicine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "delete") { (action, view, completionHandler) in
            self.delete(row: indexPath.row)
            completionHandler(true)
        }
        
        action.image = UIImage(named: "delete")
        action.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

// MARK: UITextField Helper Methods
extension PrescriptionViewController : UITextFieldDelegate {
    
    @objc func donePressed() {
        txtFieldPatient.resignFirstResponder()
        txtFieldDays.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
