//
//  AddCreditCardViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MFCard

class AddCreditCardViewController: UIViewController, MFCardDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Show(_ sender: Any) {
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        myCard.showCard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func cardTypeDidIdentify(_ cardType: String) {
        print(cardType)
    }

    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        print(card as Any)
        print(error as Any)
    }
    
}
