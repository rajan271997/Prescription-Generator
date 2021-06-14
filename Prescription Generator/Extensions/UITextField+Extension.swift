//
//  UITextField+Extension.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 13/06/21.
//

import UIKit

extension UITextField {
    
    typealias ToolbarItem = (title: String, target: Any, selector: Selector)
    
    func addToolbar(leading: [ToolbarItem] = [], trailing: [ToolbarItem] = []) {
        let toolbar = UIToolbar()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leadingItems = leading.map { item in
            return UIBarButtonItem(title: item.title, style: .plain, target: item.target, action: item.selector)
        }
        
        let trailingItems = trailing.map { item in
            return UIBarButtonItem(title: item.title, style: .plain, target: item.target, action: item.selector)
        }
        
        var toolbarItems: [UIBarButtonItem] = leadingItems
        toolbarItems.append(flexibleSpace)
        toolbarItems.append(contentsOf: trailingItems)
        
        toolbar.setItems(toolbarItems, animated: false)
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
}
