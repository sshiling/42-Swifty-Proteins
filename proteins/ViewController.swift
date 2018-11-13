//
//  ViewController.swift
//  proteins
//
//  Created by Sergiy SHILINGOV on 11/13/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    let context = LAContext()
    var error: NSError?
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func authWithTouchID(_ sender: Any) {
        let reason = "Authenticate with Touch ID"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
            {(succes, error) in
                if succes {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToTableView", sender: self)
                    }
                }
                else {
                    self.showAlertController("Touch ID Authentication Failed")
                }
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isHidden = true
    
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            button.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

