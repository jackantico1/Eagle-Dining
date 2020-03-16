//
//  LowerTwoViewController.swift
//  EagleDining
//
//  Created by Jack Antico on 2/19/19.
//  Copyright © 2019 Jack Antico. All rights reserved.
//

import UIKit

class LowerTwoViewController: UIViewController {
    
    let toDoArray = ["recipe1", "recipe2", "recipe3", "recipe4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
    }
}

extension LowerTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
}
