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

class ViewController: UIViewController {
    
    var doc = Document("The doc hasn't been changed yet.")
    struct GlobalVariable {
        static var NutritientDict = [String: Array<Any>]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var functions = Functions.functions()
        writeDiningDollars()
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=21&locationName=Lower+Live&naFlag=1")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html = urlContent
                        self.doc = try SwiftSoup.parse(html as! String)
                    } catch Exception.Error(let type, let message) {
                        print(message)
                    } catch {
                        print("Error")
                    }
                }
            })
            task.resume()
        }
    }
    
    func writeDiningDollars() {
        //print("writeDiningDollarsCalled")
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if (uid != nil) {
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let agoraUsername = value?["agoraUsername"] as? String ?? ""
                let agoraPassword = value?["agoraPassword"] as? String ?? ""
                
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
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    

    @IBAction func goToMacPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "macSegue", sender: self)
    }
    
    @IBAction func goToLowerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "lowerSegue", sender: doc)
    }
    
    
    @IBAction func diningDollarPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "segueFromHomeToDiningDollar", sender: self)
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

