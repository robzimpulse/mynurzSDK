//
//  MynurzSDKProtocol.swift
//  Pods
//
//  Created by Robyarta on 5/5/17.
//
//

import Foundation
import SwiftyJSON

public enum ErrorCode: Int {
    case None = 100000,
    InvalidResponseData,
    RejectedByServer,
    RequestError,
    NoNetwork
}

public enum RequestCode: Int {
    case None = 100000,
    
    Login,
    RegisterCustomer,
    RegisterFreelancer,
    ResetLink,
    Setting,
    Logout
    
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?)
    func responseSuccess(message: String, code: RequestCode, data: JSON)
}
