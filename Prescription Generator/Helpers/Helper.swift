//
//  Helper.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import UIKit

class Helper {
    
    private init() {} // Singleton Pattern
    
    static var instance = Helper() // Single Instance
    
    var userDefaults = UserDefaults.standard
    
    func storyboardWithName(name : String) -> UIStoryboard {
        let storyBoard = UIStoryboard(name: name, bundle: nil)
        return storyBoard
    }
    
    func createAlert(title : String,message : String,cancelButtonVisible : Bool,preferredStyle : UIAlertController.Style,action : ((UIAlertAction) -> Void )?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if (cancelButtonVisible) {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: action))
        return alertController
    }
    
    func showAlert(controller : UIViewController,title : String,message : String,style : UIAlertController.Style,cancelButtonVisible : Bool,action : ((UIAlertAction) -> Void)?) {
        let alert = createAlert(title: title, message: message, cancelButtonVisible: cancelButtonVisible, preferredStyle: style, action: action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func addTextFieldToAlert(alert : UIAlertController,placeHolder : String) {
        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
    }
    
    func share(message : String,controller : UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.view
        controller.present(activityViewController, animated: true, completion: nil)
    }
    
    func sharePrescription(patientName : String,days : String,medicines : [Medicine],controller : UIViewController) {
        
        let medicinesToString = medicines.map( { "\n Medicine Name - \($0.name ?? "") and \($0.times) times" } ).joined(separator: "\n")
        
        
        let message = """
            Presription of the Patient Name - \(patientName)        \(days) days

            Medicines are :

            \(medicinesToString)

                                By:
                                Dr. Rajan Arora
        
        """
        
        share(message: message, controller: controller)
        
    }
}
