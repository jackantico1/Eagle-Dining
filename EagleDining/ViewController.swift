//
//  ViewController.swift
//  EagleDining
//
//  Created by Jack Antico on 11/20/18.
//  Copyright © 2018 Jack Antico. All rights reserved.

import UIKit
import Alamofire
import SwiftSoup
import Firebase

struct defaultsKeys {
    static let agoraUsername = "invalidUsername"
    static let agoraPassword = "invalidPassword"
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        writeDiningDollars()
    }
    
    func writeDiningDollars() {

        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //Get agora username and password from database
        if (uid != nil) {
            
            let defaults = UserDefaults.standard
            let agoraUsername = defaults.string(forKey: defaultsKeys.agoraUsername) ?? "invalid username"
            let agoraPassword = defaults.string(forKey: defaultsKeys.agoraPassword) ?? "invalid password"
                
            //Get residentialMealPlanBalance and set value in Database
            let url1 = URL(string: "https://us-central1-bc-dining-menus.cloudfunctions.net/getResidentialMealPlan?username=\(agoraUsername)&password=\(agoraPassword)&userID=\(uid!)")!
            let task1 = URLSession.shared.dataTask(with: url1) {(data, response, error) in
                guard let data = data else { return }
                //print("residentialMealPlanBalance is:")
                let residentialMealPlanBalance = String(data: data, encoding: .utf8)!
                //print(residentialMealPlanBalance)
                ref.child("users/\(uid!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    ref.child("users/\(uid!)/diningDollars/residentialMealPlan").setValue(["residentialMealPlan": residentialMealPlanBalance])
                    //print("Database update 1 went through")
                }) { (error) in
                    print("ERROR (SignUpViewController):" + error.localizedDescription)
                }
            }
            task1.resume()
            
            //Get residentialDiningBucksBalance and set value in Database
            let url2 = URL(string: "https://us-central1-bc-dining-menus.cloudfunctions.net/getResidentialDiningBucks?username=\(agoraUsername)&password=\(agoraPassword)&userID=\(uid!)")!
            let task2 = URLSession.shared.dataTask(with: url2) {(data, response, error) in
                guard let data = data else { return }
                //print("residentialDiningBucks is:")
                let residentialDiningBucksBalance = String(data: data, encoding: .utf8)!
                //print(residentialDiningBucksBalance)
                ref.child("users/\(uid!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    ref.child("users/\(uid!)/diningDollars/residentialDiningBucks").setValue(["residentialDiningBucks": residentialDiningBucksBalance])
                    //print("Database update 2 went through")
                }) { (error) in
                    print("ERROR (SignUpViewController):" + error.localizedDescription)
                }
            }
            task2.resume()
            
            //Get studentEagleBucksBalance and set value in Database
            let url3 = URL(string: "https://us-central1-bc-dining-menus.cloudfunctions.net/getStudentEagleBucks?username=\(agoraUsername)&password=\(agoraPassword)&userID=\(uid!)")!
            let task3 = URLSession.shared.dataTask(with: url3) {(data, response, error) in
                guard let data = data else { return }
                //print("studentEagleBucksBalance is:")
                let studentEagleBucksBalance = String(data: data, encoding: .utf8)!
                print(studentEagleBucksBalance)
                ref.child("users/\(uid!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    ref.child("users/\(uid!)/diningDollars/studentEagleBucks").setValue(["studentEagleBucks": studentEagleBucksBalance])
                    //print("Database update 3 went through")
                }) { (error) in
                    print("ERROR (SignUpViewController):" + error.localizedDescription)
                }
            }
            task3.resume()

        }
    }
    
    @IBAction func diningDollarPressed(_ sender: UIButton) {
        print("diningDollarsPressed called, Auth.auth().currentUser: \(Auth.auth().currentUser)")
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "segueFromHomeToDiningDollars", sender: self)
        } else {
            performSegue(withIdentifier: "segueFromHomeToLogin", sender: self)
        }
    }
    
    
}

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

