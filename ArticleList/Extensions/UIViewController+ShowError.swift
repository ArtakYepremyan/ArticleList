//
//  UIViewController+ShowError.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(error: ALError) {
        switch error {
        case .http(let statusCode):
            presentAlert(withTitle: "Error", message: "Status code \(statusCode)")
        case .network(let error):
            presentAlert(withTitle: "Error", message: error?.localizedDescription)
        case .parsing(let error):
            presentAlert(withTitle: "Parsing Error", message: error.localizedDescription)
        case .custom(let descriptions):
            presentAlert(withTitle: "Error", message: String(descriptions.joined()))
        case .data:
            presentAlert(withTitle: "Error", message: "Data Error")
        case .unknown:
            presentAlert(withTitle: "Error", message: "Unknown error")
        }
    }
    
    func presentAlert(withTitle title:String?, message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        self.present(alert, animated: true)
    }
}

