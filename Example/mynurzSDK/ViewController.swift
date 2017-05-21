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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sdk.setDelegate(delegate: self)
        self.sdk.login(email: "customer@kronusasia.com", password: "11111")
        Timer.runThisAfterDelay(seconds: 10.0, after: {
            self.sdk.getProfileCustomer()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print("Response error on \(self.className) : \(message) - \(code) - \(errorCode)")
        print(data as Any)
    }
    
    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print("Response success on \(self.className) : \(message) - \(code)")
        print(data)
    }
    
}

