//
//  DiningDollarsBalance.swift
//  EagleDining
//
//  Created by Jack Antico on 9/1/19.
//  Copyright © 2019 Jack Antico. All rights reserved.
//

import Foundation
import SwiftSoup
import Firebase
import Alamofire

class DiningDollarsBalanceController: UIViewController {
    
    
    @IBOutlet weak var residentialMealPlanLabel: UILabel!
    @IBOutlet weak var residentialDiningBucksLabel: UILabel!
    @IBOutlet weak var studentEagleBucksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        if (userID != nil) {
            ref.child("users").child(userID!).child("diningDollars/residentialMealPlan").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let residentialMealPlan = value?["residentialMealPlan"] as? String ?? "999.99"
                self.residentialMealPlanLabel.text = "$\(residentialMealPlan)"
            }) { (error) in
                print(error.localizedDescription)
            }
            
            ref.child("users").child(userID!).child("diningDollars/residentialDiningBucks").observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let residentialDiningBucks = value?["residentialDiningBucks"] as? String ?? "999.99"
                            self.residentialDiningBucksLabel.text = "$\(residentialDiningBucks)"
                        }) { (error) in
                            print(error.localizedDescription)
                        }
            ref.child("users").child(userID!).child("diningDollars/studentEagleBucks").observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let studentEagleBucks = value?["studentEagleBucks"] as? String ?? "999.99"
                            self.studentEagleBucksLabel.text = "$\(studentEagleBucks)"
                        }) { (error) in
                            print(error.localizedDescription)
                        }
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          let alert = UIAlertController(title: "Error", message: "\(signOutError)", preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "segueFromDiningDollarsToHome", sender: self)
        }
    }
    
}
