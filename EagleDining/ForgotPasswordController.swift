//
//  ForgotPasswordController.swift
//  EagleDining
//
//  Created by Jack Antico on 1/8/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
    }
    
    @IBAction func sendPasswordResetPressed(_ sender: UIButton) {
        
        let email =  emailField?.text ?? "Invalid email"
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                let alert = UIAlertController(title: "Success", message: "Your password reset email is on its way!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
