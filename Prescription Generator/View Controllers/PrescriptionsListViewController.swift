//
//  PrescriptionsListViewController.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 14/06/21.
//

import UIKit

class PrescriptionsListViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: Class Members
    var prescriptions = [Prescription]()
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "").elementsEqual("PrescriptionSegue") {
            let prescriptionVC = segue.destination as! PrescriptionViewController
            let prescription = prescriptions[sender as! Int]
            prescriptionVC.medicines = Array(prescription.rawMedicines!)
            prescriptionVC.prescription = prescription
        }
    }
    
    // MARK: Actions
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    func registerNibs() {
        tableView.register(UINib(nibName: "PrescriptionInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PrescriptionInfoTableViewCell")
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 250.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero) // Hide extra rows
    }
    
}

// MARK: UITableView Methods
extension PrescriptionsListViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionInfoTableViewCell", for: indexPath) as? PrescriptionInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(prescription: prescriptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PrescriptionSegue", sender: indexPath.row)
    }
    
}

