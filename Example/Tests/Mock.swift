//
//  Mock.swift
//  mynurzSDK
//
//  Created by Robyarta on 5/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import mynurzSDK
import SwiftyJSON
import EZSwiftExtensions

class Mock: NSObject, MynurzSDKDelegate {

    var message: String?
    var code: RequestCode?
    
    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print("Response success : \(message) - \(code) - \(self.className)")
        self.message = message
        self.code = code
    }
    
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print("Response error : \(message) - \(code) - \(errorCode) - \(self.className)")
        self.message = message
        self.code = code
    }
}
