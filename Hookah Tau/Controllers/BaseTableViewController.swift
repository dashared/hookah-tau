//
//  BaseTableViewController.swift
//  Hookah Tau
//
//  Created by cstore on 07/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

   // MARK: - Alert
    
   func displayAlert(forError error: GeneralError = GeneralError.noData, with message: String? = nil) {
       var title: String? = message == nil ? error.localizedDescription : message
       switch error {
       case .serverError(let se):
           title = se.error
           fallthrough // да тоже произведение искусства
       default:
           let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }

}
