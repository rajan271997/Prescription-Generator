//
//  ViewController.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import UIKit

class MedicinesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewPrescrption: UIView!
    @IBOutlet var txtFieldSearch: UITextField! {
        didSet {
            let cancelButton = UITextField.ToolbarItem(title: "Cancel", target: self, selector: #selector(cancelPressed))
            let doneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(donePressed))
            txtFieldSearch.addToolbar(leading: [cancelButton], trailing: [doneButton])
        }
    }
    
    // MARK: Class Members
    var medicineViewModel : MedicineViewModel?
    var isSearchEnabled = false
    var prescription = [String : Medicine]()
    var selectedMedicine : Medicine?
    var addMedicineViewController : AddMedicineViewController?
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        setupUI()
        setupModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "").elementsEqual("PrescriptionSegue") {
            let prescriptionVC = segue.destination as! PrescriptionViewController
            prescriptionVC.medicines = Array(prescription.values)
            prescriptionVC.resetState = {
                self.resetMedicines()
            }
        } else if (segue.identifier ?? "").elementsEqual("PrescriptionsListSegue") {
            let prescriptions = sender as! [Prescription]
            let prescriptionListVC = segue.destination as! PrescriptionsListViewController
            prescriptionListVC.prescriptions = prescriptions
        }
    }
    
    // MARK: Actions
    @IBAction func showSavedPrescriptions(_ sender: Any) {
        CoreDataHelper.instance.getPrescription { (prescriptions) in
            if (prescriptions.count > 0) {
                performSegue(withIdentifier: "PrescriptionsListSegue", sender: prescriptions)
            } else {
                Helper.instance.showAlert(controller: self, title: "Alert", message: "No Data Found !!", style: .alert, cancelButtonVisible: false, action: nil)
            }
        }
    }
    
    @IBAction func reloadPage(_ sender: Any) {
        Helper.instance.showAlert(controller: self, title: "Alert", message: "Do you want to delete medicines and create new prescription?", style: .alert, cancelButtonVisible: true) { (action) in
            self.resetMedicines()
        }
    }
    
    // MARK: Helper Methods
    func setupModel() {
        medicineViewModel = MedicineViewModel()
        
        self.medicineViewModel!.bindMedicinesViewModelToController = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.medicineViewModel?.getMedicines()
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "MedicineTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicineTableViewCell")
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 250.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero) // Hide extra rows
    }
    
    func getMoreData() {
        self.medicineViewModel?.getMoreMedicines()
    }
    
    func showAddMedicineView() {
        if (addMedicineViewController == nil) {
            let storyBoard = Helper.instance.storyboardWithName(name: "Main")
            addMedicineViewController = storyBoard.instantiateViewController(identifier: "AddMedicineViewController") as? AddMedicineViewController
        }
        addMedicineViewController?.name = selectedMedicine!.name
        self.view.addSubview(addMedicineViewController!.view)
        
        addMedicineViewController?.dozes = { dozes in
            self.prescription.removeValue(forKey: self.selectedMedicine!.name ?? "")
            let medicine = self.selectedMedicine
            medicine?.times = Int64(dozes)
            self.prescription.updateValue(medicine!, forKey: medicine!.name ?? "")
            self.viewPrescrption.isHidden ? self.viewPrescrption.isHidden = false : nil
        }
    }
    
    func resetMedicines() {
        self.prescription.removeAll()
        self.viewPrescrption.isHidden = true
    }
}

// MARK: UITableView Methods
extension MedicinesViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medicineViewModel?.medicines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.medicineViewModel!.medicines!.count - 5 == indexPath.row && self.medicineViewModel!.hasMoreData && !isSearchEnabled) {
            getMoreData()
        }
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineTableViewCell", for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(medicine: (medicineViewModel?.medicines?[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMedicine = self.medicineViewModel!.medicines![indexPath.row]
        showAddMedicineView()
    }
    
}

// MARK: UITextField Helper Methods
extension MedicinesViewController : UITextFieldDelegate {
    @objc func cancelPressed() {
        isSearchEnabled = false
        txtFieldSearch.text = ""
        txtFieldSearch.resignFirstResponder()
        medicineViewModel?.getMedicines()
    }
    
    @objc func donePressed() {
        searchMedicine(txtfield: txtFieldSearch)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMedicine(txtfield: textField)
        return true
    }
    
    func checkTxtFieldEmpty(txtField : UITextField) -> Bool {
        let text = (txtField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? true : false
    }
    
    func searchMedicine(txtfield : UITextField) {
        txtFieldSearch.resignFirstResponder()
        
        if (checkTxtFieldEmpty(txtField: txtfield)) {
            medicineViewModel?.getMedicines()
            isSearchEnabled = false
        } else {
            medicineViewModel?.searchMedicine(keyword: txtfield.text ?? "")
            isSearchEnabled = true
        }
    }
}
