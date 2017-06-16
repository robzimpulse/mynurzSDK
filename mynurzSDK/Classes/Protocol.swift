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
    InvalidRequestData,
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
    RefreshToken,
    ResetLink,
    SearchCustomer,
    SearchFreelancer,
    GetFirebaseToken,
    Logout,
    
    GetSkills,
    GetSkillExperiences,
    GetRoles,
    GetReligions,
    GetPromotionCategories,
    GetProfessions,
    GetJobStatuses,
    GetEmployments,
    GetDegrees,
    GetRelationships,
    GetCountries,
    GetStates,
    GetCities,
    GetDistricts,
    GetAreas,
    
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
    UpdateNationalityFreelancer,
    UpdateNationalityFreelancerProgress,
    
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
    UpdateNationalityCustomer,
    UpdateNationalityCustomerProgress,
    
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
    PublishInquiryCustomer,
    
    GetAvailableInquiryFreelancer,
    GetAllProposalFreelancer,
    AddProposalFreelancer,
    AddCollaboratorProposalFreelancer,
    RemoveCollaboratorProposalFreelancer,
    UpdateProposalFreelancer,
    UpdateProposalFreelancerProgress,
    SubmitProposalFreelancer,
    
    ReceivedChat,
    UpdateLocation,
    ChargeStripe,
    ChargeOmise
}

public protocol MynurzSDKDelegate {
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?)
    func responseSuccess(message: String, code: RequestCode, data: JSON)
}
