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

    let sdk = MynurzSDK.local
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sdk.delegate = self
        sdk.wipeDatabase()
        sdk.login(email: "customer@example.org", password: "kiasu123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func responseSuccess(message: String, code: MynurzSDKRequestCode, data: JSON) {
        print("response success: \(message) - \(code)")
        print("current token : \(TokenController.shared.get()?.token as Any)")
    }
    
    func responseError(message: String, code: MynurzSDKRequestCode, errorCode: MynurzSDKErrorCode, data: JSON?) {
        print("response error: \(message) - \(code) - \(errorCode)")
        print("current token : \(TokenController.shared.get()?.token as Any)")
    }
}

