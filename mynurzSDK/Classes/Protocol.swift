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
    UpdateAddress,
    UpdateName,
    UpdatePassword,
    UpdatePhone,
    
    GetPatient,
    AddPatient,
    AddPatientProgress,
    UpdatePatient,
    UpdatePatientProgress,
    RemovePatient
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?)
    func responseSuccess(message: String, code: RequestCode, data: JSON)
}

extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}
