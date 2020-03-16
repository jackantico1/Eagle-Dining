//
//  LowerViewController.swift
//
//
//  Created by Jack Antico on 2/3/19.
//

import UIKit
import SwiftSoup

class EaglesViewController: UIViewController {
    
    
    @IBOutlet weak var mealTime: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var eaglesMenuItems = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=23%28a%29&locationName=Eagle%27s+Nest&naFlag=1")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html: String = urlContent! as String
                        let els: Elements = try SwiftSoup.parse(html).getElementsByClass("shortmenurecipes")
                        for link: Element in els.array() {
                            let linkText: String = try link.text()
                            self.eaglesMenuItems.append(linkText)
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
    
    func formatLunch(allItems: [String]) -> [String] {
        var lunchItems = [String()]
        for item in allItems {
            if item == "Green-It" {
                break
            }
            lunchItems.append(item)
        }
        lunchItems.removeSubrange(0...1)
        return lunchItems
    }
}

extension EaglesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mealItems = formatLunch(allItems: eaglesMenuItems)
        return mealItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mealItems = formatLunch(allItems: eaglesMenuItems)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mealItems[indexPath.row]
        cell.backgroundColor = UIColor.init(red: 148.0/256.0, green: 23.0/256.0, blue: 81.0/256.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.init(red: 255.0/256.0, green: 251.0/256.0, blue: 0.0/256.0, alpha: 1.0)
        return cell
    }
    
}
