//
//  NutrientsController.swift
//  
//
//  Created by Jack Antico on 10/9/19.
//

import UIKit
import Alamofire
import SwiftSoup
import Firebase

class NutrientsController: UIViewController {
    
    var mealItem: String = ""

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var proteinCount: UILabel!
    @IBOutlet weak var carbsCount: UILabel!
    @IBOutlet weak var fatCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var NutritientDict = [String: Array<Any>]()
        NutritientDict["Belgian Waffles"] = [459.728, 5.108, 90.243, 8.513]
        
    }
    
    
    
}
