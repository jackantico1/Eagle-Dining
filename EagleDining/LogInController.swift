//
//  LogInController.swift
//  EagleDining
//
//  Created by Jack Antico on 9/1/19.
//  Copyright © 2019 Jack Antico. All rights reserved.
//

import UIKit
import Firebase
import Mixpanel

class LoginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendEventToMixpanel()
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        let email =  emailField?.text ?? "Invalid email"
        let password = passwordField?.text ?? "Invalid password"
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error == nil {
                self?.performSegue(withIdentifier: "segueFromLogInToMain", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sendEventToMixpanel() {
        Mixpanel.mainInstance().track(event: "log_in_page_visited")
    }
    
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
