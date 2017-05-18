//
//  DataManager.swift
//  Pods
//
//  Created by Robyarta on 5/16/17.
//
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions

class DataManager: NSObject {

    public static let sharedInstance = DataManager()
    
    let tokenController = TokenController.sharedInstance
    let settingController = SettingController.sharedInstance
    let profileController = ProfileController.sharedInstance
    
    func putData(code:RequestCode, data: JSON){
        switch code {
        case .Login:
            guard let tokenExpiredAt = data["data"]["token_expired_at"].int else {return}
            guard let tokenLimitToRefresh = data["data"]["token_limit_to_refresh"].int else {return}
            guard let token = data["data"]["token"].string else {return}
            guard let tokenIssueAt = data["data"]["token_issued_at"].int else {return}
            guard let roleId = data["data"]["role_id"].int else {return}
            tokenController.put(token: token, tokenIssuedAt: tokenIssueAt, tokenExpiredAt: tokenExpiredAt, tokenLimitToRefresh: tokenLimitToRefresh, roleId: roleId)
            return
        case .Setting:
            guard let skills = data["data"]["skills"].array else {return}
            guard let roles = data["data"]["roles"].array else {return}
            guard let professions = data["data"]["professions"].array else {return}
            guard let jobStatuses = data["data"]["job_statuses"].array else {return}
            guard let countries = data["data"]["countries"].array else {return}
            guard let promotionCategories = data["data"]["promotion_categories"].array else {return}
            guard let skillExperiences = data["data"]["skill_experiences"].array else {return}
            guard let religions = data["data"]["religions"].array else {return}
            guard let employments = data["data"]["employments"].array else {return}
            guard let degrees = data["data"]["degrees"].array else {return}
            guard let relationships = data["data"]["relationships"].array else {return}
            
            settingController.drop()
            
            for role in skills {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(skillWithId: id, name: name)
            }
            
            for role in roles {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in professions {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in jobStatuses {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in countries {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in promotionCategories {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in skillExperiences {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in employments {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for religion in religions {
                guard let id = religion["id"].int else {continue}
                guard let name = religion["name"].string else {continue}
                settingController.put(religionWithId: id, name: name)
            }
            
            for role in degrees {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(roleWithId: id, name: name)
            }
            
            for role in relationships {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(relationshipWithId: id, name: name)
            }
            return
        case .GetStates:
            settingController.dropState()
            guard let states = data["data"].array else {return}
            for role in states {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(stateWithId: id, name: name)
            }
            return
        case .GetCities:
            settingController.dropCity()
            guard let cities = data["data"].array else {return}
            for role in cities {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(cityWithId: id, name: name)
            }
            return
        case .GetDistricts:
            settingController.dropDistrict()
            guard let districts = data["data"].array else {return}
            for role in districts {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(districtWithId: id, name: name)
            }
            return
        case .GetAreas:
            settingController.dropArea()
            guard let areas = data["data"].array else {return}
            for role in areas {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                settingController.put(areaWithId: id, name: name)
            }
            return
        case .GetProfile:
            guard let id = data["data"]["id"].int else {return}
            guard let firstName = data["data"]["first_name"].string else {return}
            guard let lastName = data["data"]["last_name"].string else {return}
            guard let email = data["data"]["email"].string else {return}
            guard let phone = data["data"]["phone"].string else {return}
            guard let roleId = data["data"]["role_id"].int else {return}
            guard let createdAt = data["data"]["created_at"].int else {return}
            guard let updatedAt = data["data"]["updated_at"].int else {return}
            guard let uid = data["data"]["customer_data"]["uid"].string else {return}
            guard let photo = data["data"]["customer_data"]["photo"].string else {return}
            guard let address = data["data"]["customer_data"]["address"].string else {return}
            guard let countryCode = data["data"]["customer_data"]["country_code"].int else {return}
            guard let stateId = data["data"]["customer_data"]["state_id"].int else {return}
            guard let cityId = data["data"]["customer_data"]["city_id"].int else {return}
            guard let districtId = data["data"]["customer_data"]["district_id"].int else {return}
            guard let areaId = data["data"]["customer_data"]["area_id"].int else {return}
            guard let zipCode = data["data"]["customer_data"]["zip_code"].string else {return}
            
            profileController.putCustomer(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone, roleId: roleId, createdAt: createdAt, updatedAt: updatedAt, uid: uid, photo: photo, address: address, countryCode: countryCode, stateId: stateId, cityId: cityId, districtId: districtId, areaId: areaId, zipCode: zipCode)
            return
        case .Logout:
            profileController.drop()
            settingController.drop()
            tokenController.drop()
            return
        default:
            print("Unhandled \(code) on \(self.className)")
            print(data)
            return
        }
    }
    
}