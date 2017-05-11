//
//  MynurzSDKProtocol.swift
//  Pods
//
//  Created by Robyarta on 5/5/17.
//
//

import Foundation
import SwiftyJSON

public enum MynurzSDKErrorCode: Int {
    case None = 100000,
    InvalidResponseData,
    RejectedByServer,
    RequestError,
    NoNetwork
}

public enum MynurzSDKStateDevelopment: Int {
    case Live = 100000,
    Staging,
    Local
}

public enum MynurzSDKRequestCode: Int {
    case None = 100000,
    
    UpdateLocation,
    UpdateOnlineState,
    
    Login,
    ForgetPassword,
    Logout,
    GetProfile,
    UpdateName,
    UpdatePassword,
    UpdatePhone,
    
    RegisterFreelancer,
    UpdateFreelancerSubscription,
    UpdateFreelancerPhotoProfile,
    UpdateFreelancerIDCard,
    UpdateFreelancerProfile,
    UpdateFreelancerPackagePrice,
    
    RegisterCustomer,
    UpdateCustomerSubscription,
    UpdateCustomerPhotoProfile,
    UpdateCustomerAddress
    
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: MynurzSDKRequestCode, errorCode: MynurzSDKErrorCode, data: JSON?)
    func responseSuccess(message: String, code: MynurzSDKRequestCode, data: JSON)
}
