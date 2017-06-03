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
    
    lazy var cleanHost: String = {return self.host.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")}()
    
    // MARK: - Authentication
    
    lazy var PUSHER_PRIVATE: String = {return self.host.appending("/api/pusher_private")}()
    lazy var PUSHER_PRESENCE: String = {return self.host.appending("/api/pusher_presence")}()
    lazy var LOGIN: String = {return self.host.appending("/api/login")}()
    lazy var REGISTER_CUSTOMER: String = {return self.host.appending("/api/register_customer")}()
    lazy var REGISTER_FREELANCER: String = {return self.host.appending("/api/register_freelancer")}()
    lazy var RESET_LINK: String = {return self.host.appending("/api/reset")}()
    lazy var REFRESH_TOKEN: String = {return self.host.appending("/api/refresh_token")}()
    lazy var SETTING: String = {return self.host.appending("/api/setting")}()
    lazy var GET_STATE: String = {return self.host.appending("/api/states")}()
    lazy var GET_CITY: String = {return self.host.appending("/api/cities")}()
    lazy var GET_DISTRICT: String = {return self.host.appending("/api/districts")}()
    lazy var GET_AREA: String = {return self.host.appending("/api/areas")}()
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
