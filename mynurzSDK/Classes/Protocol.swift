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
    
    GetProfileFreelancer,
    UpdatePhotoFreelancer,
    UpdatePhotoFreelancerProgress,
    UpdateIDCardFreelancer,
    UpdateIDCardFreelancerProgress,
    UpdateSubscribeFreelancer,
    UpdateSubscribeFreelancerProgress,
    UpdateNameFreelancer,
    UpdateNameFreelancerProgress,
    UpdatePasswordFreelancer,
    UpdatePasswordFreelancerProgress,
    UpdatePhoneFreelancer,
    UpdatePhoneFreelancerProgress,
    UpdatePackagePriceFreelancer,
    UpdatePackagePriceFreelancerProgress,
    UpdateProfileFreelancer,
    UpdateProfileFreelancerProgress,
    UpdateAddressFreelancer,
    UpdateAddressFreelancerProgress,
    
    GetProfileCustomer,
    UpdatePhotoCustomer,
    UpdatePhotoCustomerProgress,
    UpdateSubscribeCustomer,
    UpdateSubscribeCustomerProgress,
    UpdateAddressCustomer,
    UpdateAddressCustomerProgress,
    UpdateNameCustomer,
    UpdateNameCustomerProgress,
    UpdatePasswordCustomer,
    UpdatePasswordCustomerProgress,
    UpdatePhoneCustomer,
    UpdatePhoneCustomerProgress,
    
    GetPatientCustomer,
    AddPatientCustomer,
    AddPatientCustomerProgress,
    UpdatePatientCustomer,
    UpdatePatientCustomerProgress,
    RemovePatientCustomer,
    RemovePatientCustomerProgress,
    
    GetInquiryCustomer,
    AddInquiryCustomer,
    AddInquiryCustomerProgress,
    UpdateInquiryCustomer,
    UpdateInquiryCustomerProgress,
    
    ReceivedChat,
    UpdateLocation
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?)
    func responseSuccess(message: String, code: RequestCode, data: JSON)
}
