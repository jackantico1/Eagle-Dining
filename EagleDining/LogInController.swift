//
//  LogInController.swift
//  EagleDining
//
//  Created by Jack Antico on 9/1/19.
//  Copyright © 2019 Jack Antico. All rights reserved.
//

import Foundation
import SwiftSoup
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        let email =  emailField?.text ?? "Invalid email"
        let password = passwordField?.text ?? "Invalid password"
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error == nil {
                print("LogInViewController: User was succesfully signed in")
                self?.performSegue(withIdentifier: "segueFromLogInToMain", sender: nil)
            } else {
                print("There was an error in login controller")
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
