//
//  Utilities.swift
//  SQLiteLearn
//
//  Created by Mac Mini-07 on 3/19/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    static let sharedInstance = Utilities()
    
    let loginDataKey = "kBatch141LoginData"
    
    func showAlert(obj: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel) {
            (action) in alert.dismiss(animated: true, completion: nil)
            obj.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        obj.present(alert, animated: true, completion: nil)
    }

}
