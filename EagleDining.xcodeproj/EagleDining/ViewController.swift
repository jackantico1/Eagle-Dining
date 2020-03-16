//
//  ViewController.swift
//  EagleDining
//
//  Created by Jack Antico on 11/20/18.
//  Copyright © 2018 Jack Antico. All rights reserved.

import UIKit
import Alamofire
import SwiftSoup

/*
 
Running list of Bugs
    1. Need to figure out way to track day of week as to edit the formatMeal functions so they always work properly
    2. Need to make logo to use for pictures on landing and report issues view controllers
    3. Need to test contrainsts more fully on diffrent iphones
    4. Need to figure out way to poll users on what feature they want next
 
 */

class ViewController: UIViewController {
    
    var doc = Document("The doc hasn't been changed yet")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://foodpro.bc.edu/foodpro/shortmenu.asp?sName=BC+DINING&locationNum=21&locationName=Lower+Live&naFlag=1")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    do {
                        let html = urlContent
                        self.doc = try SwiftSoup.parse(html as! String)
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
    

    @IBAction func goToMacPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "macSegue", sender: self)
    }
    
    @IBAction func goToLowerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "lowerSegue", sender: doc)
    }
    
}

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

