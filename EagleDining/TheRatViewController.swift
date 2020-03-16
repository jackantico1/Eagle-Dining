//
//  LowerViewController.swift
//
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup
import Firebase

class TheRatViewController: UIViewController {
    
    
    
    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var theRatMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("buttonUsage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let ratUsage = value?["ratUsage"] as? Int ?? 0
            ref.child("buttonUsage/ratUsage").setValue(ratUsage + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=25&locationName=Lyons+Hall&naFlag=1")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("shortmenurecipes")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.theRatMenuItems.append(linkText)
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
        if breakfastItems.count > 2 {
            breakfastItems.removeSubrange(0...1)
            breakfastItems.append(contentsOf: ["", "", "", ""])
        } else {
            breakfastItems = ["Sorry, Breakfast isn't being served :(",  "", "", "", "", "", ""]
        }
        
        return breakfastItems
    }
    
    func formatLunch(allItems: [String]) -> [String] {
        var hitLunch = false
        var lunchItems = [String()]
        for item in allItems {
            if hitLunch == true {
                lunchItems.append(item)
            }
            if item == "Turkey Sandwich on Multigrain" { //note this works 6/7 times
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
    
}

extension TheRatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: theRatMenuItems)
        case 1:
            mealItems = formatLunch(allItems: theRatMenuItems)
        default:
            mealItems = formatLunch(allItems: theRatMenuItems)
        }
        return mealItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = [String()]
        switch mealTime.selectedSegmentIndex {
        case 0:
            mealItems = formatBreakfast(allItems: theRatMenuItems)
        case 1:
            mealItems = formatLunch(allItems: theRatMenuItems)
        default:
            mealItems = formatLunch(allItems: theRatMenuItems)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
