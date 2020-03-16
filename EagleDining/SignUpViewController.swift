//
//  SignUpViewController.swift
//  EagleDining
//
//  Created by Jack Antico on 9/1/19.
//  Copyright © 2019 Jack Antico. All rights reserved.
//

import Foundation
import SwiftSoup
import Firebase

class SignUpController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var agoraUsernameField: UITextField!
    @IBOutlet weak var agoraPasswordField: UITextField!
    @IBOutlet weak var classYearSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        let email = emailField?.text ?? "Invalid Username"
        let password = passwordField?.text ?? "Invalid Password"
        let agoraUsername = agoraUsernameField?.text ?? "Invalid Agora Username"
        let agoraPassword = agoraPasswordField?.text ?? "Invalid Agora Password"
        let classYear = classYearSegment.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user, error == nil {
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                    ref.child("users/\(user.uid)").setValue(["agoraUsername": agoraUsername, "agoraPassword": agoraPassword, "email": email, "classYear": classYear])
                }) { (error) in
                    print("ERROR (SignUpViewController):" + error.localizedDescription)
                }
                
                self.performSegue(withIdentifier: "segueFromSignUpToMain", sender: nil)
            } else {
                let alert = UIAlertController(title: "ERROR!!!", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                print("ERROR (SignUpController): Couldn't make the user")
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
}
