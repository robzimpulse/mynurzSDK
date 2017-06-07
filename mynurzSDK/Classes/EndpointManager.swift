//
//  EndpointManager.swift
//  Pods
//
//  Created by Robyarta on 5/15/17.
//
//

import UIKit

public enum gender: String {
    case male = "male"
    case female = "female"
}

public class EndpointManager: NSObject {

    public static let sharedInstance = EndpointManager()
    
    var host = "http://mynurznew.app"
    var midtransClientKey = "VT-client-AoZKEG2XOkHtEPw2"
    var omisePublicKey = "pkey_test_58820b5b9axpbqqmmgv"
    var stripePublishableKey = "pk_test_sE3n6dQNn01rQzfXP89fKMcx"
    
    lazy var cleanHost: String = {return self.host.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")}()
    
    // MARKL - Midtrans merchant url
    
    lazy var MIDTRANS_CHARGE: String = {return self.host.appending("/api/midtrans")}()
    lazy var STRIPE_CHARGE: String = {return self.host.appending("/api/stripe/charge")}()
    
    // MARK: - Authentication
    
    lazy var PUSHER_PRIVATE: String = {return self.host.appending("/api/pusher_private")}()
    lazy var PUSHER_PRESENCE: String = {return self.host.appending("/api/pusher_presence")}()
    lazy var LOGIN: String = {return self.host.appending("/api/login")}()
    lazy var REGISTER_CUSTOMER: String = {return self.host.appending("/api/register_customer")}()
    lazy var REGISTER_FREELANCER: String = {return self.host.appending("/api/register_freelancer")}()
    lazy var RESET_LINK: String = {return self.host.appending("/api/reset")}()
    lazy var REFRESH_TOKEN: String = {return self.host.appending("/api/refresh_token")}()
    
    lazy var GET_SKILL: String = {return self.host.appending("/api/setting/skills")}()
    lazy var GET_SKILL_EXPERIENCE: String = {return self.host.appending("/api/setting/skill_experiences")}()
    lazy var GET_ROLE: String = {return self.host.appending("/api/setting/roles")}()
    lazy var GET_RELIGION: String = {return self.host.appending("/api/setting/religions")}()
    lazy var GET_PROMOTION_CATEGORY: String = {return self.host.appending("/api/setting/promotion_categories")}()
    lazy var GET_PROFESSION: String = {return self.host.appending("/api/setting/professions")}()
    lazy var GET_JOB_STATUS: String = {return self.host.appending("/api/setting/job_statuses")}()
    lazy var GET_EMPLOYMENT: String = {return self.host.appending("/api/setting/employments")}()
    lazy var GET_DEGREE: String = {return self.host.appending("/api/setting/degrees")}()
    lazy var GET_RELATIONSHIP: String = {return self.host.appending("/api/setting/relationships")}()
    lazy var GET_COUNTRY: String = {return self.host.appending("/api/setting/countries")}()
    lazy var GET_STATE: String = {return self.host.appending("/api/setting/states")}()
    lazy var GET_CITY: String = {return self.host.appending("/api/setting/cities")}()
    lazy var GET_DISTRICT: String = {return self.host.appending("/api/setting/districts")}()
    lazy var GET_AREA: String = {return self.host.appending("/api/setting/areas")}()
    
    lazy var FIREBASE_TOKEN: String = {return self.host.appending("/api/firebase_token")}()
    lazy var LOGOUT: String = {return self.host.appending("/api/logout")}()
    
    // MARK: - Customer End Point
    
    lazy var CUSTOMER_PHOTO: String = {return self.host.appending("/api/customer/photo")}()
    lazy var CUSTOMER_SUBSCRIBE: String = {return self.host.appending("/api/customer/subscribe")}()
    lazy var CUSTOMER_ADDRESS: String = {return self.host.appending("/api/customer/address")}()
    lazy var CUSTOMER_PROFILE: String = {return self.host.appending("/api/customer/profile")}()
    lazy var CUSTOMER_NAME: String = {return self.host.appending("/api/customer/name")}()
    lazy var CUSTOMER_PASSWORD: String = {return self.host.appending("/api/customer/password")}()
    lazy var CUSTOMER_PHONE: String = {return self.host.appending("/api/customer/phone")}()
    lazy var CUSTOMER_NATIONALITY: String = {return self.host.appending("/api/customer/nationality")}()
    
    lazy var CUSTOMER_SEARCH_FREELANCER: String = {return self.host.appending("/api/customer/search_freelancer")}()
    lazy var CUSTOMER_SEARCH_CUSTOMER: String = {return self.host.appending("/api/customer/search_customer")}()
    
    lazy var CUSTOMER_PATIENT_GET: String = {return self.host.appending("/api/customer/patient")}()
    lazy var CUSTOMER_PATIENT_ADD: String = {return self.host.appending("/api/customer/patient/add")}()
    lazy var CUSTOMER_PATIENT_UPDATE: String = {return self.host.appending("/api/customer/patient/update")}()
    lazy var CUSTOMER_PATIENT_REMOVE: String = {return self.host.appending("/api/customer/patient/remove")}()
    
    lazy var CUSTOMER_INQUIRY_GET: String = {return self.host.appending("/api/customer/inquiry")}()
    lazy var CUSTOMER_INQUIRY_ADD: String = {return self.host.appending("/api/customer/inquiry/add")}()
    lazy var CUSTOMER_INQUIRY_UPDATE: String = {return self.host.appending("/api/customer/inquiry/update")}()
    lazy var CUSTOMER_INQUIRY_PUBLISH: String = {return self.host.appending("/api/customer/inquiry/publish")}()
    
    // MARK: - Freelancer End Point
    
    lazy var FREELANCER_PHOTO: String = {return self.host.appending("/api/freelancer/photo")}()
    lazy var FREELANCER_IDCARD: String = {return self.host.appending("/api/freelancer/id_card")}()
    lazy var FREELANCER_PROFILE: String = {return self.host.appending("/api/freelancer/profile")}()
    lazy var FREELANCER_SUBSCRIBE: String = {return self.host.appending("/api/freelancer/subscribe")}()
    lazy var FREELANCER_PACKAGE_PRICE: String = {return self.host.appending("/api/freelancer/package_price")}()
    lazy var FREELANCER_NAME: String = {return self.host.appending("/api/freelancer/name")}()
    lazy var FREELANCER_PASSWORD: String = {return self.host.appending("/api/freelancer/password")}()
    lazy var FREELANCER_PHONE: String = {return self.host.appending("/api/freelancer/phone")}()
    lazy var FREELANCER_ADDRESS: String = {return self.host.appending("/api/freelancer/address")}()
    lazy var FREELANCER_NATIONALITY: String = {return self.host.appending("/api/freelancer/nationality")}()
    
    lazy var FREELANCER_SEARCH_FREELANCER: String = {return self.host.appending("/api/freelancer/search_freelancer")}()
    lazy var FREELANCER_SEARCH_CUSTOMER: String = {return self.host.appending("/api/freelancer/search_customer")}()
    
    lazy var FREELANCER_ACADEMIC_ADD: String = {return self.host.appending("/api/freelancer/academic/add")}()
    lazy var FREELANCER_ACADEMIC_UPDATE: String = {return self.host.appending("/api/freelancer/academic/update")}()
    lazy var FREELANCER_ACADEMIC_REMOVE: String = {return self.host.appending("/api/freelancer/academic/remove")}()
    
    lazy var FREELANCER_TRAINING_ADD: String = {return self.host.appending("/api/freelancer/training/add")}()
    lazy var FREELANCER_TRAINING_UPDATE: String = {return self.host.appending("/api/freelancer/training/update")}()
    lazy var FREELANCER_TRAINING_REMOVE: String = {return self.host.appending("/api/freelancer/training/remove")}()
    
    lazy var FREELANCER_WORKING_AREA_ADD: String = {return self.host.appending("/api/freelancer/working_area/add")}()
    lazy var FREELANCER_WORKING_AREA_REMOVE: String = {return self.host.appending("/api/freelancer/working_area/remove")}()
    
    lazy var FREELANCER_SKILL_ADD: String = {return self.host.appending("/api/freelancer/skill/add")}()
    lazy var FREELANCER_SKILL_UPDATE: String = {return self.host.appending("/api/freelancer/skill/update")}()
    lazy var FREELANCER_SKILL_REMOVE: String = {return self.host.appending("/api/freelancer/skill/remove")}()
    
    lazy var FREELANCER_WORKING_EXPERIENCE_ADD: String = {return self.host.appending("/api/freelancer/working_experience/add")}()
    lazy var FREELANCER_WORKING_EXPERIENCE_UPDATE: String = {return self.host.appending("/api/freelancer/working_experience/update")}()
    lazy var FREELANCER_WORKING_EXPERIENCE_REMOVE: String = {return self.host.appending("/api/freelancer/working_experience/remove")}()
    
    lazy var FREELANCER_INQUIRY_GET: String = {return self.host.appending("/api/freelancer/inquiries")}()
    lazy var FREELANCER_PROPOSAL_GET: String = {return self.host.appending("/api/freelancer/proposal")}()
    lazy var FREELANCER_PROPOSAL_ADD: String = {return self.host.appending("/api/freelancer/proposal/add")}()
    lazy var FREELANCER_PROPOSAL_UPDATE: String = {return self.host.appending("/api/freelancer/proposal/update")}()
    lazy var FREELANCER_PROPOSAL_SUBMIT: String = {return self.host.appending("/api/freelancer/proposal/submit")}()
    lazy var FREELANCER_PROPOSAL_COLLABORATOR_ADD: String = {return self.host.appending("/api/freelancer/proposal/collaborator/add")}()
    lazy var FREELANCER_PROPOSAL_COLLABORATOR_REMOVE: String = {return self.host.appending("/api/freelancer/proposal/collaborator/remove")}()
    
}
