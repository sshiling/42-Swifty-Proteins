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
    var proteinsArr: [String] = []
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        loginView.text = ""
        passwordView.text = ""
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToTableView", sender: self)
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func authWithTouchID(_ sender: Any) {
        self.button.isEnabled = false
        let reason = "Authenticate with Touch ID"
        loginView.text = ""
        passwordView.text = ""
        loginView.resignFirstResponder()
        passwordView.resignFirstResponder()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
            {(succes, error) in
                if succes {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToTableView", sender: self)
                        self.button.isEnabled = true
                    }
                    
                }
                else {
                    self.showAlertController("Touch ID Authentication Failed")
                    self.button.isEnabled = true
                }
            })
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isHidden = true
    
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            button.isHidden = false
        }
        
        let fileURLProject = Bundle.main.path(forResource: "ligands", ofType: "txt")
        var readStringProject = ""
        
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: fileURLProject)), Error: " + error.localizedDescription)
        }
        proteinsArr = readStringProject.components(separatedBy: "\n").filter({!$0.isEmpty})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTableView" {
            let destinationVC = segue.destination as! TableViewController
            
            destinationVC.names = proteinsArr
        }
    }
}





