//
//  PopupWebviewViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import PTPopupWebView

class PopupWebviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Show(_ sender: Any) {
        let popupvc = PTPopupWebViewController()
        _ = popupvc
            .popupView
            .URL(string: "https://mynurz.com/")
            .addButton(PTPopupWebViewButton(type: .close).title("close"))
        
        popupvc
            .popupAppearStyle(.spread(0.4))
            .popupDisappearStyle(.spread(0.4))
            .show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

}
