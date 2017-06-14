//
//  BlurPopupViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MIBlurPopup

class BlurPopupViewController: UIViewController, MIBlurPopupDelegate {
    
    @IBOutlet weak var cardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var popupView: UIView {
        return self.cardView
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 1.5
    }
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}
