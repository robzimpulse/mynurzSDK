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
    
//    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sdk.setDelegate(delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.sdk.getCountry()
//        
//        let picker = CountryTablePicker()
//        picker.didSelectClosure = { (id, name, countryCode, countryCodeIso3)  in
//            print(id,name,countryCode,countryCodeIso3)
//            picker.dismiss(animated: true)
//        }
//        
//        
//        Timer.runThisAfterDelay(seconds: 5.0, after: {_ in
//            self.present(picker, animated: true)
//        })
        
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

