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

class MacViewController: UIViewController {

    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var defaultsData = UserDefaults.standard
    var macMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        self.tableView.backgroundView = bgView
        
        updateButtonPressedData()
    }
    
    
    @IBAction func mealTimeChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    func formatBreakfast(allItems: [String]) -> [String] {
        var leftBreakfast = false
        var breakfastItems = [String()]
        
        if !Calendar.current.isDateInWeekend(Date()) {
            for item in allItems {
                if item == "Turkey Sandwich on Multigrain" {
                    break
                }
                if !leftBreakfast {
                    breakfastItems.append(item)
                }
            }
        } else {
            for item in allItems {
                if item == "Onion Rings" {
                    leftBreakfast = true
                }
                if !leftBreakfast {
                    breakfastItems.append(item)
                }
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
        var lunchItems = [String()]
        
        if !Calendar.current.isDateInWeekend(Date()) {
            for item in allItems {
                if item == "Onion Rings" {
                    break
                }
                if hitLunch == true {
                    lunchItems.append(item)
                }
                if item == "Turkey Sandwich on Multigrain" {
                    hitLunch = true
                }
            }
        } else {
            for item in allItems {
                if item == "Onion Rings" {
                    break
                }
                if hitLunch == true {
                    lunchItems.append(item)
                }
                if item == "Bacon (3 slices)" {
                    hitLunch = true
                }
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
        var counter1 = 1
        var counter2 = 0
        var dinnerItems = [String()]
        
        
        for item in allItems {
            if item == "Onion Rings" {
                counter1 += 1
                counter2 += 1
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
    
    func formatLateNight(allItems: [String]) -> [String] {
        var counter1 = 0
        var hitLateNight = false
        var lateNightItems = [String()]
        
        for item in allItems {
            
            if item == "Onion Rings" {
                counter1 += 1
            }
            
            if counter1 == 2 {
                hitLateNight = true
            }
            
            if hitLateNight {
                lateNightItems.append(item)
            }
        }
        
        if lateNightItems.count > 2 {
            lateNightItems.remove(at: 0)
        } else {
            lateNightItems = ["Sorry, Late Night isn't being served :(", "", "", "", "", "", ""]
        }
        
        return lateNightItems
    }
    
    func updateButtonPressedData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("buttonUsage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let macUsage = value?["macUsage"] as? Int ?? 0
            ref.child("buttonUsage/macUsage").setValue(macUsage + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func mainMenuPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "main_menu_pressed")
    }
    
    
    @IBAction func reportIssuePressed(_ sender: UIButton) {
        Analytics.logEvent("report_issue_pressed_mac", parameters: nil)
        Mixpanel.mainInstance().track(event: "report_issue_pressed")
    }
    
    
}

extension MacViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: macMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_breakfast")
        case 1:
            mealItems = formatLunch(allItems: macMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_lunch")
        case 2:
            mealItems = formatDinner(allItems: macMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_dinner")
        case 3:
            mealItems = formatLateNight(allItems: macMenuItems)
            Mixpanel.mainInstance().track(event: "viewed_latenight")
        default:
            mealItems = formatDinner(allItems: macMenuItems)
        }
        return mealItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
            case 0:
                mealItems = formatBreakfast(allItems: macMenuItems)
            case 1:
                mealItems = formatLunch(allItems: macMenuItems)
            case 2:
                mealItems = formatDinner(allItems: macMenuItems)
            case 3:
                mealItems = formatLateNight(allItems: macMenuItems)
            default:
                mealItems = formatDinner(allItems: macMenuItems)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
}
