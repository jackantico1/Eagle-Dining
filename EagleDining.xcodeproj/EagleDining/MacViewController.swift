//
//  LowerViewController.swift
//
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup

class MacViewController: UIViewController {
    
    

    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var macMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        print(Calendar.current.isDateInWeekend(Date()))
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=23&locationName=Carney%27s&naFlag=1&WeeksMenus=This+Week%27s+Menus&myaction=read&dtdate=4%2F8%2F2019")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("shortmenurecipes")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.macMenuItems.append(linkText)
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
        if Calendar.current.isDateInWeekend(Date()) {
            breakfastItems = formatLunch(allItems: allItems)
        }
        if breakfastItems.count > 2 {
            breakfastItems.removeSubrange(0...1)
        }
        if !leftBreakfast && Calendar.current.isDateInWeekend(Date()) {
            breakfastItems = ["Sorry, Breakfast isn't being served",  "", "", "", "", "", ""]
        }
        return breakfastItems
    }
    
    func formatLunch(allItems: [String]) -> [String] {
        var hitLunch = false
        var leftLunch = true
        var lunchItems = [String()]
        for item in allItems {
            if item == "Onion Rings" {
                break
            }
            if hitLunch == true {
                lunchItems.append(item)
            }
            if item == "Turkey Sandwich on Multigrain" { //note this works 6/7 times
                hitLunch = true
            }
        }
        if lunchItems.count > 2 {
            lunchItems.remove(at: 0)
        }
        if !hitLunch {
            lunchItems = ["Sorry, Lunch isn't being served",  "", "", "", "", "", ""]
        }
        return lunchItems
    }
    
    func formatDinner(allItems: [String]) -> [String] {
        var counter1 = 1
        var counter2 = 0
        var hitDinner = false
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
        }
        if counter2 != 2 {
            dinnerItems = ["Sorry, Dinner isn't being served tonight", "", "", "", "", "", ""]
        }
        return dinnerItems
    }
    
    func formatLateNight(allItems: [String]) -> [String] {
        var hitLateNight = false
        var lateNightItems = [String()]
        for item in allItems {
            if item == "Cold Wraps" {
                hitLateNight = true
            }
            if hitLateNight {
                lateNightItems.append(item)
            }
        }
        if lateNightItems.count > 2 {
            lateNightItems.remove(at: 0)
        }
        if !hitLateNight {
            lateNightItems = ["Sorry, Late Night isn't being served", "", "", "", "", "", ""]
        }
        return lateNightItems
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    
    
}

extension MacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
