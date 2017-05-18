//
//  ViewController.swift
//  mynurzSDK
//
//  Created by kugelfang.killaruna@gmail.com on 05/11/2017.
//  Copyright (c) 2017 kugelfang.killaruna@gmail.com. All rights reserved.
//

import UIKit
import mynurzSDK
import SwiftyJSON

class ViewController: UIViewController, MynurzSDKDelegate {
    
    let sdk = MynurzSDK.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print("Response error on \(self.className) : \(message) - \(code) - \(errorCode)")
    }
    
    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print("Response success on \(self.className) : \(message) - \(code)")
    }
    
}

