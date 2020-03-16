//
//  LowerViewController.swift
//
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup

class ChocolateBarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var defaultsData = UserDefaults.standard
    var chocolateBarMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/chocolate.html")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("MsoNormal")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.chocolateBarMenuItems.append(linkText)
                        }
                        
                        var chocolateBarMenuItemsCopy = [String()]
                        var counter = 0
                        for item in self.chocolateBarMenuItems {
                            if item != "" {
                                chocolateBarMenuItemsCopy.append(item)
                            }
                            counter += 1
                        }
                        
                        self.chocolateBarMenuItems = chocolateBarMenuItemsCopy
                        print(self.chocolateBarMenuItems)
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
    
    
    func formatMenu(allItems: [String]) -> [String] {
        var menuItems = allItems
        if menuItems.count > 3 {
             menuItems.removeSubrange(0...2)
        }
        return menuItems
    }
    
}

extension ChocolateBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = formatMenu(allItems: chocolateBarMenuItems)
        return mealItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = formatMenu(allItems: chocolateBarMenuItems)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
