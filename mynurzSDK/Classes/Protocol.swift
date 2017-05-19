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
    NoNetwork,
    NoNetworkPusher
}

public enum RequestCode: Int {
    case None = 100000,
    
    Login,
    RegisterCustomer,
    RegisterFreelancer,
    ResetLink,
    Setting,
    GetStates,
    GetCities,
    GetDistricts,
    GetAreas,
    Logout,
    
    GetProfile,
    UpdatePhoto,
    UpdatePhotoProgress,
    UpdateSubscribe,
    UpdateSubscribeProgress,
    UpdateAddress,
    UpdateAddressProgress,
    UpdateName,
    UpdateNameProgress,
    UpdatePassword,
    UpdatePasswordProgress,
    UpdatePhone,
    UpdatePhoneProgress,
    
    GetPatient,
    AddPatient,
    AddPatientProgress,
    UpdatePatient,
    UpdatePatientProgress,
    RemovePatient,
    RemovePatientProgress
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?)
    func responseSuccess(message: String, code: RequestCode, data: JSON)
}
