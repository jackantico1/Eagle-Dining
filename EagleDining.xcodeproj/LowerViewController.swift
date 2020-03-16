//
//  LowerViewController.swift
//  
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup

class LowerViewController: UIViewController {
    
    
    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var lowerMenuItems = [String()]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=21&locationName=Lower+Live&naFlag=1&WeeksMenus=This+Week%27s+Menus&myaction=read&dtdate=4%2F8%2F2019")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("shortmenurecipes")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.lowerMenuItems.append(linkText)
                        }
                        
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
        var leftBreakfast = false
        var breakfastItems = [String()]
        for item in allItems {
            if item == "Baby Arugula Parmesan Salad" {
                leftBreakfast = true
            }
            if !leftBreakfast {
                breakfastItems.append(item)
            }
        }
        breakfastItems.removeSubrange(0...1)
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
        lunchItems.remove(at: 0)
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
        dinnerItems.remove(at: 0)
        return dinnerItems
    }
    
    func formatLateNight(allItems: [String]) -> [String] {
        var counter1 = 1
        var counter2 = 0
        var hitLateNight = false
        var lateNightItems = [String()]
        for item in allItems {
            if item == "Onion Rings" { //note this works 6/7 times
                counter1 += 1
                counter2 += 1
            }
            if counter2 == 3 {
                break
            }
            if counter1 == 3 && counter2 == 2 {
                lateNightItems.append(item)
            }
        }
        lateNightItems.removeSubrange(0...1)
        return lateNightItems
    }
    
}

extension LowerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
