//
//  MedicineViewModel.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import Foundation

class MedicineViewModel {
    
    private(set) var medicines : [Medicine]? {
        didSet {
            self.bindMedicinesViewModelToController()
        }
    }
    
    private var totalMedicines = [Medicine]()
    var hasMoreData = true
    
    var bindMedicinesViewModelToController : (() -> ()) = {}
    
    func getMedicines() {
        LoadingIndicator.shared.start()
        getLocalData()
    }
    
    func getMoreMedicines() {
        let length = medicines!.count + 9
        if (length > totalMedicines.count - 1 && hasMoreData) {
            self.medicines = Array(totalMedicines[0..<length])
        } else {
            hasMoreData = false
            self.medicines = totalMedicines
        }
    }
    
    func searchMedicine(keyword : String) {
        hasMoreData = true
        let results = self.totalMedicines.filter({ ($0.name ?? "").lowercased().contains(keyword.lowercased()) })
        self.medicines = results
    }
    
    private func getMedicinesFromServer(medicinesInfo : @escaping (MedicineInfo) -> Void) {
        WebServiceHelper.instance.performRequest(type: .GET_MEDICINES) { (result) in
            switch result {
            case .success(let data) :
                let jsonDecoder = JSONDecoder()
                do {
                    let medicines = try jsonDecoder.decode(MedicineInfo.self, from: data as! Data)
                    medicinesInfo(medicines)
                }catch {
                    LoadingIndicator.shared.stop()
                    print(error.localizedDescription)
                }
            case .failure(let error):
                LoadingIndicator.shared.stop()
                print(error.localizedDescription)
            }
        }
    }
    
    private func getLocalData() {
        CoreDataHelper.instance.getMedicines { (medicines) in
            if (medicines.count <= 0) {
                getMedicinesFromServer { (medicineInfos) in
                    DispatchQueue.main.async {
                        CoreDataHelper.instance.addMedicines(medicines: medicineInfos)
                        self.getLocalData()
                    }
                }
            } else {
                totalMedicines = medicines
                DispatchQueue.main.async {
                    LoadingIndicator.shared.stop()
                    self.medicines = Array(medicines[0..<10])
                }
            }
        }
    }
}
