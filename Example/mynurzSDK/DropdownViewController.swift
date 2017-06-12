//
//  DropdownViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import DropDown
import MIBadgeButton_Swift

class DropdownViewController: UIViewController {
    
    var dropdown: DropDown? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let validDropDown = DropDown()
        validDropDown.dataSource = [
            "Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck",
            "Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck",
            "Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck"
        ]
        DropDown.startListeningToKeyboard()
        validDropDown.width = 200
        dropdown = validDropDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func Show(_ sender: Any) {
        guard let buttonSender = sender as? UIButton else {return}
        guard let validDropdown = dropdown else {return}
        validDropdown.anchorView = buttonSender
        validDropdown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
        validDropdown.show()
    }
    
}
