//
//  AlertUtils.swift
//  Stock Watch
//
//  Created by DERMALOG on 08/03/2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        ac.message = message
        let submitAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(submitAction)
        self.present(ac, animated: true)
    }
    
}
