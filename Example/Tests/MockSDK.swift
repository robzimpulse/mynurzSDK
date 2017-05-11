//
//  MockSDK.swift
//  mynurzSDK
//
//  Created by Robyarta on 4/25/17.
//  Copyright © 2017 kronus. All rights reserved.
//

import SwiftyJSON
import mynurzSDK

class MockSDK: MynurzSDKDelegate {
    
    var lastCode: MynurzSDKRequestCode?
    var lastErrorCode: MynurzSDKErrorCode?
    var lastData: JSON?
    
    func responseError(message: String, code: MynurzSDKRequestCode, errorCode: MynurzSDKErrorCode, data: JSON?) {
        self.lastCode = code
        self.lastErrorCode = errorCode
        print("response error : \(message) - \(code)")
    }
    
    func responseSuccess(message: String, code: MynurzSDKRequestCode, data: JSON) {
        self.lastCode = code
        self.lastErrorCode = nil
        print("response success : \(message) - \(code)")
    }
}
