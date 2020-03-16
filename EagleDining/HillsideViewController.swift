//
//  LowerViewController.swift
//
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup
import Firebase

class HillsideViewController: UIViewController {
    
    
    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var hillsideMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("buttonUsage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let hillsideUsage = value?["hillsideUsage"] as? Int ?? 0
            ref.child("buttonUsage/hillsideUsage").setValue(hillsideUsage + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=02&locationName=Hillside+Cafe&naFlag=1")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("shortmenurecipes")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.hillsideMenuItems.append(linkText)
                        }
                        print(self.hillsideMenuItems)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch Exception.Error(let type, let message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                }
            })
            task.resume()
            
        }
    }
    
    
    @IBAction func mealTimeChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    func formatBreakfast(allItems: [String]) -> [String] {
        
        
        var breakfastItems = [String()]
        
        if !Calendar.current.isDateInWeekend(Date()) {
            for item in allItems {
                if item == "Turkey Sandwich on Multigrain" {
                    break
                }
                breakfastItems.append(item)
            }
        } else {
            breakfastItems = ["Sorry, Breakfast isn't being served :(", "", "", "", "", "", ""]
        }
        
        breakfastItems.remove(at: 0)
        breakfastItems.remove(at: 0)
        return breakfastItems
    }
    
    func formatLunch(allItems: [String]) -> [String] {
        
        var hitLunch = false
        var lunchItems = [String()]
        
        if !Calendar.current.isDateInWeekend(Date()) {
            for item in allItems {
                if item == "Entree Garden Salad " {
                    break
                }
                if item == "Plain Croissants" {
                    hitLunch = true
                }
                if hitLunch {
                    lunchItems.append(item)
                }
            }
        } else {
            lunchItems = ["Sorry, Lunch isn't being served today :(", "", "", "", "", "", ""]
        }
        
        lunchItems.remove(at: 0)
        return lunchItems
    }
    
    func formatDinner(allItems: [String]) -> [String] {
    
        var hitDinner = false
        var dinnerItems = [String()]
        
        if !Calendar.current.isDateInWeekend(Date()) {
            for item in allItems {
                if item == "Entree Garden Salad" {
                    hitDinner = true
                }
                if hitDinner {
                    dinnerItems.append(item)
                }
            }
        } else {
            dinnerItems = ["Sorry, Dinner isn't being served today :(", "", "", "", "", "", ""]
        }
        
        dinnerItems.remove(at: 0)
        return dinnerItems
    }
    
}

extension HillsideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: hillsideMenuItems)
        case 1:
            mealItems = formatLunch(allItems: hillsideMenuItems)
        case 2:
            mealItems = formatDinner(allItems: hillsideMenuItems)
        default:
            mealItems = formatDinner(allItems: hillsideMenuItems)
        }
        return mealItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: hillsideMenuItems)
        case 1:
            mealItems = formatLunch(allItems: hillsideMenuItems)
        case 2:
            mealItems = formatDinner(allItems: hillsideMenuItems)
        default:
            mealItems = formatDinner(allItems: hillsideMenuItems)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
