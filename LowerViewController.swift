//
//  LowerViewController.swift
//  
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup
import Firebase
import Mixpanel

class LowerViewController: UIViewController {
    
    
    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var lowerMenuItems = [String()]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateButtonUsage()
    }
    
    
    @IBAction func mealTimeChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    func formatBreakfast(allItems: [String]) -> [String] {
        var leftBreakfast = false
        var breakfastItems = [String()]
        for item in allItems {
            if item == "Turkey Sandwich on Multigrain" {
                leftBreakfast = true
            }
            if !leftBreakfast {
                breakfastItems.append(item)
            }
        }
        
        if breakfastItems.count > 2 {
            breakfastItems.removeSubrange(0...1)
        } else {
            breakfastItems = ["Sorry, Breakfast isn't being served :(",  "", "", "", "", "", ""]
        }
        
        return breakfastItems
    }
    
    func formatLunch(allItems: [String]) -> [String] {
        var hitLunch = false
        var leftLunch = true
        var lunchItems = [String()]
        for item in allItems {
            if item == "Additional Chicken Breast" {
                break
            }
            if hitLunch == true {
               lunchItems.append(item)
            }
            if item == "Vegetarian Entree Value Meal" { //note this works 6/7 times
                hitLunch = true
            }
        }
        if lunchItems.count > 2 {
            lunchItems.remove(at: 0)
        } else {
            lunchItems = ["Sorry, Lunch isn't being served today :(",  "", "", "", "", "", ""]
        }
        return lunchItems
    }
    
    func formatDinner(allItems: [String]) -> [String] {
        var counter1 = 0
        var counter2 = 0
        var hitDinner = false
        var dinnerItems = [String()]
        for item in allItems {
            if item == "Additional Chicken Breast" {
                counter2 += 1
            }
            if item == "Vegetarian Entree Value Meal" { //note this works 6/7 times
                counter1 += 1
            }
            if counter2 == 2 {
                break
            }
            if counter1 == 2 && counter2 == 1 {
                dinnerItems.append(item)
            }
        }
        if dinnerItems.count > 3 {
            dinnerItems.removeSubrange(0...1)
        }  else {
            dinnerItems = ["Sorry, Dinner isn't being served tonight :(", "", "", "", "", "", ""]
        }
        return dinnerItems
    }
    
    @IBAction func mainMenuPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "main_menu_pressed")
    }
    
    @IBAction func reportIssuePressed(_ sender: UIButton) {
        Analytics.logEvent("report_issue_pressed_lower", parameters: nil)
        Mixpanel.mainInstance().track(event: "report_issue_pressed")
    }
    
    func updateButtonUsage() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("buttonUsage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let lowerUsage = value?["lowerUsage"] as? Int ?? 0
            ref.child("buttonUsage/lowerUsage").setValue(lowerUsage + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

extension LowerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: lowerMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_breakfast")
        case 1:
            mealItems = formatLunch(allItems: lowerMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_lunch")
        case 2:
            mealItems = formatDinner(allItems: lowerMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_dinner")
        default:
            mealItems = formatDinner(allItems: lowerMenuItems)
        }
        return mealItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: lowerMenuItems)
        case 1:
            mealItems = formatLunch(allItems: lowerMenuItems)
        case 2:
            mealItems = formatDinner(allItems: lowerMenuItems)
        default:
            mealItems = formatDinner(allItems: lowerMenuItems)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
}
