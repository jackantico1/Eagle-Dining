//
//  PrivacyViewController.swift
//  EagleDining
//
//  Created by Jack Antico on 3/16/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Mixpanel

class PrivacyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendEventToMixpanel()
    }
    
    func sendEventToMixpanel() {
        Mixpanel.mainInstance().track(event: "privacy_page_visited")
    }
    
}
