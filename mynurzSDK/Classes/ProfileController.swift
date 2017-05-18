//
//  ProfileController.swift
//  Pods
//
//  Created by Robyarta on 5/17/17.
//
//

//
//  Profile.swift
//  mynurz
//
//  Created by Robyarta on 5/12/17.
//  Copyright © 2017 kronus. All rights reserved.
//

import Foundation
import RealmSwift

public class freelancerProfile: Object {
    dynamic public var id = 0
    dynamic public var firstName = ""
    dynamic public var lastName = ""
    dynamic public var email = ""
    dynamic public var phone = ""
    dynamic public var roleId = 0
    dynamic public var createdAt = 0
    dynamic public var updatedAt = 0
    
    dynamic public var uid = ""
    dynamic public var profession = 0
    dynamic public var gender = ""
    dynamic public var religion = 0
    dynamic public var photo = ""
    dynamic public var idCard = ""
    dynamic public var countryCode = 0
    dynamic public var packagePrice = 0
}

public class customerProfile: Object {
    dynamic public var id = 0
    dynamic public var firstName = ""
    dynamic public var lastName = ""
    dynamic public var email = ""
    dynamic public var phone = ""
    dynamic public var roleId = 0
    dynamic public var createdAt = 0
    dynamic public var updatedAt = 0
    
    dynamic public var uid = ""
    dynamic public var photo = ""
    dynamic public var address = ""
    dynamic public var countryCode = 0
    dynamic public var stateId = 0
    dynamic public var cityId = 0
    dynamic public var districtId = 0
    dynamic public var areaId = 0
    dynamic public var zipCode = ""
}

public class ProfileController {
    
    public static let sharedInstance = ProfileController()
    private var realm: Realm?
    
    public func getFreelancer() -> freelancerProfile? {
        self.realm = try! Realm()
        return self.realm!.objects(freelancerProfile.self).first
    }
    
    public func getCustomer() -> customerProfile? {
        self.realm = try! Realm()
        return self.realm!.objects(customerProfile.self).first
    }
    
    public func putFreelancer(id: Int, firstName: String, lastName: String, email: String, phone: String, roleId: Int, createdAt: Int, updatedAt: Int, uid: String, profession: Int, gender: String, religion: Int, photo: String, idCard: String, countryCode: Int, packagePrice: Int){
        self.realm = try! Realm()
        try! self.realm!.write {
            let freelancer = freelancerProfile()
            freelancer.id = id
            freelancer.firstName = firstName
            freelancer.lastName = lastName
            freelancer.email = email
            freelancer.phone = phone
            freelancer.roleId = roleId
            freelancer.createdAt = createdAt
            freelancer.updatedAt = updatedAt
            freelancer.uid = uid
            freelancer.profession = profession
            freelancer.gender = gender
            freelancer.religion = religion
            freelancer.photo = photo
            freelancer.idCard = idCard
            freelancer.countryCode = countryCode
            freelancer.packagePrice = packagePrice
            if let oldFreelancer = self.realm!.objects(freelancerProfile.self).first {
                self.realm?.delete(oldFreelancer)
            }
            self.realm!.add(freelancer)
        }
    }
    
    public func putCustomer(id: Int, firstName: String, lastName: String, email: String, phone: String, roleId: Int, createdAt: Int, updatedAt: Int, uid: String, photo: String, address: String, countryCode: Int, stateId: Int, cityId: Int, districtId: Int, areaId: Int, zipCode: String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let customer = customerProfile()
            customer.id = id
            customer.firstName = firstName
            customer.lastName = lastName
            customer.email = email
            customer.phone = phone
            customer.roleId = roleId
            customer.createdAt = createdAt
            customer.updatedAt = updatedAt
            customer.uid = uid
            customer.photo = photo
            customer.address = address
            customer.countryCode = countryCode
            customer.stateId = stateId
            customer.cityId = cityId
            customer.districtId = districtId
            customer.areaId = areaId
            customer.zipCode = zipCode
            if let oldCustomer = self.realm!.objects(customerProfile.self).first {
                self.realm?.delete(oldCustomer)
            }
            self.realm!.add(customer)
        }
    }
    
    public func drop(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm?.delete((self.realm?.objects(freelancerProfile.self))!)
            self.realm?.delete((self.realm?.objects(customerProfile.self))!)
        }
    }
}
