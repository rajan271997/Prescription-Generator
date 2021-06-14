//
//  CoreDataHelper.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    private init () {} // Singleton Pattern
    
    static var instance = CoreDataHelper()
    
    // MARK: Expose Methods
    func getMedicines(medicines : (([Medicine]) -> Void)) {
        getMedicinesFromDatabase(entityName: "Medicine", entities: medicines)
    }
    
    func addMedicines(medicines : MedicineInfo) {
        self.addMedicinesToDatabase(medicines: medicines)
    }
    
    func addPrescription(name : String,patientName : String?,medicines : Set<Medicine>) {
        guard  let managedContext = getManagedObjectContext() else {
            return
        }
        
        let prescriptionModel = Prescription(context: managedContext)
        prescriptionModel.name = name
        prescriptionModel.patientName = patientName
        prescriptionModel.addToRawMedicines(medicines)
        
        do {
            try managedContext.save()
            print("Saved ")
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getPrescription(prescriptions : ([Prescription]) -> Void){
        getPrescriptionsFromDatabase(entityName: "Prescription", entities: prescriptions)
    }
    
    // MARK: Private Methods
    private func getMedicinesFromDatabase(entityName : String,entities : (([Medicine]) -> Void)) {
        guard let managedContext = getManagedObjectContext() else {
            return
        }
        
        let fetchRequest = NSFetchRequest<Medicine>(entityName: entityName)
        
        do {
            let medicines = try managedContext.fetch(fetchRequest)
            entities(medicines)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func getPrescriptionsFromDatabase(entityName : String,entities : (([Prescription]) -> Void)) {
        guard let managedContext = getManagedObjectContext() else {
            return
        }
        
        let fetchRequest = NSFetchRequest<Prescription>(entityName: entityName)
        
        do {
            let prescriptions = try managedContext.fetch(fetchRequest)
            entities(prescriptions)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func addMedicinesToDatabase(medicines : MedicineInfo) {
        
        guard  let managedContext = getManagedObjectContext() else {
            return
        }
        
        for medicineInfo in medicines {
            let medicine = Medicine(context: managedContext)
            medicine.id = Int64(medicine.id)
            medicine.name = medicineInfo.name
            medicine.type = medicineInfo.type
            medicine.company = medicineInfo.company
            medicine.strength = medicineInfo.strength
            medicine.strengthType = medicineInfo.strengthtype
        }
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
}
