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
    lazy var LOGOUT: String = {return self.host.appending("/api/logout")}()
    
    // MARK: - Customer End Point
    
    lazy var CUSTOMER_PHOTO: String = {return self.host.appending("/api/customer/photo")}()
    lazy var CUSTOMER_SUBSCRIBE: String = {return self.host.appending("/api/customer/subscribe")}()
    lazy var CUSTOMER_ADDRESS: String = {return self.host.appending("/api/customer/address")}()
    lazy var CUSTOMER_PROFILE: String = {return self.host.appending("/api/customer/profile")}()
    lazy var CUSTOMER_NAME: String = {return self.host.appending("/api/customer/name")}()
    lazy var CUSTOMER_PASSWORD: String = {return self.host.appending("/api/customer/password")}()
    lazy var CUSTOMER_PHONE: String = {return self.host.appending("/api/customer/phone")}()
    
    lazy var GET_CUSTOMER_PATIENT: String = {return self.host.appending("/api/customer/patient")}()
    lazy var ADD_CUSTOMER_PATIENT: String = {return self.host.appending("/api/customer/patient/add")}()
    lazy var UPDATE_CUSTOMER_PATIENT: String = {return self.host.appending("/api/customer/patient/update")}()
    lazy var REMOVE_CUSTOMER_PATIENT: String = {return self.host.appending("/api/customer/patient/remove")}()
    
    // MARK: - Freelancer End Point
    
    lazy var FREELANCER_PHOTO: String = {return self.host.appending("/api/freelancer/photo")}()
    lazy var FREELANCER_IDCARD: String = {return self.host.appending("/api/freelancer/id_card")}()
    lazy var FREELANCER_PROFILE: String = {return self.host.appending("/api/freelancer/profile")}()
    lazy var FREELANCER_SUBSCRIBE: String = {return self.host.appending("/api/freelancer/subscribe")}()
    lazy var FREELANCER_PACKAGE_PRICE: String = {return self.host.appending("/api/freelancer/package_price")}()
    lazy var FREELANCER_NAME: String = {return self.host.appending("/api/freelancer/name")}()
    lazy var FREELANCER_PASSWORD: String = {return self.host.appending("/api/freelancer/password")}()
    lazy var FREELANCER_PHONE: String = {return self.host.appending("/api/freelancer/phone")}()
    
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
}
