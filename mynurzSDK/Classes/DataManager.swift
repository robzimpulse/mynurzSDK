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
    
    let firebaseTokenController = FirebaseTokenController.sharedInstance
    let tokenController = TokenController.sharedInstance
    let stateController = StateController.sharedInstance
    let areaController = AreaController.sharedInstance
    let cityController = CityController.sharedInstance
    let countryController = CountryController.sharedInstance
    let degreeController = DegreeController.sharedInstance
    let districtController = DistrictController.sharedInstance
    let employmentController = EmploymentController.sharedInstance
    let jobStatusController = JobStatusController.sharedInstance
    let professionController = ProfessionController.sharedInstance
    let promotionCategoryController = PromotionCategoryController.sharedInstance
    let relationshipController = RelationshipController.sharedInstance
    let religionController = ReligionController.sharedInstance
    let roleController = RoleController.sharedInstance
    let skillController = SkillController.sharedInstance
    let skillExperienceController = SkillExperienceController.sharedInstance
    let profileController = ProfileController.sharedInstance
    public let pusherManager = PusherManager.sharedInstance
    
    func putData(code:RequestCode, data: JSON){
        switch code {
        case .Login:
            guard let tokenExpiredAt = data["data"]["token_expired_at"].string else {return}
            guard let tokenLimitToRefresh = data["data"]["token_limit_to_refresh"].string else {return}
            guard let token = data["data"]["token"].string else {return}
            guard let tokenIssueAt = data["data"]["token_issued_at"].string else {return}
            guard let roleId = data["data"]["role_id"].int else {return}
            tokenController.put(token: token, tokenIssuedAt: tokenIssueAt, tokenExpiredAt: tokenExpiredAt, tokenLimitToRefresh: tokenLimitToRefresh, roleId: roleId)
            self.pusherManager.startListening()
            return
        case .RefreshToken:
            guard let tokenExpiredAt = data["data"]["token_expired_at"].string else {return}
            guard let tokenLimitToRefresh = data["data"]["token_limit_to_refresh"].string else {return}
            guard let token = data["data"]["token"].string else {return}
            guard let tokenIssueAt = data["data"]["token_issued_at"].string else {return}
            guard let roleId = data["data"]["role_id"].int else {return}
            tokenController.put(token: token, tokenIssuedAt: tokenIssueAt, tokenExpiredAt: tokenExpiredAt, tokenLimitToRefresh: tokenLimitToRefresh, roleId: roleId)
            return
        case .GetFirebaseToken:
            guard let token = data["data"]["token"].string else {return}
            guard let tokenIssueAt = data["data"]["token_issued_at"].string else {return}
            guard let tokenExpiredAt = data["data"]["token_expired_at"].string else {return}
            firebaseTokenController.put(token:token, tokenIssuedAt: tokenIssueAt, tokenExpiredAt: tokenExpiredAt)
            return
        case .GetSkills:
            guard let skills = data["data"].array else {return}
            skillController.drop()
            for role in skills {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                skillController.put(id: id, name: name)
            }
            return
        case .GetRoles:
            guard let roles = data["data"].array else {return}
            roleController.drop()
            for role in roles {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                roleController.put(id: id, name: name)
            }
            return
        case .GetProfessions:
            guard let professions = data["data"].array else {return}
            professionController.drop()
            for role in professions {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                professionController.put(id: id, name: name)
            }
            return
        case .GetJobStatuses:
            guard let jobStatuses = data["data"].array else {return}
            jobStatusController.drop()
            for role in jobStatuses {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                jobStatusController.put(id: id, name: name)
            }
            return
        case .GetPromotionCategories:
            guard let promotionCategories = data["data"].array else {return}
            promotionCategoryController.drop()
            for role in promotionCategories {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                promotionCategoryController.put(id: id, name: name)
            }
            return
        case .GetSkillExperiences:
            guard let skillExperiences = data["data"].array else {return}
            skillExperienceController.drop()
            for role in skillExperiences {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                skillExperienceController.put(id: id, name: name)
            }
            return
        case .GetReligions:
            guard let religions = data["data"].array else {return}
            religionController.drop()
            for religion in religions {
                guard let id = religion["id"].int else {continue}
                guard let name = religion["name"].string else {continue}
                religionController.put(id: id, name: name)
            }
            return
        case .GetEmployments:
            guard let employments = data["data"].array else {return}
            employmentController.drop()
            for role in employments {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                employmentController.put(id: id, name: name)
            }
            return
        case .GetDegrees:
            guard let degrees = data["data"].array else {return}
            degreeController.drop()
            for role in degrees {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                degreeController.put(id: id, name: name)
            }
            return
        case .GetRelationships:
            guard let relationships = data["data"].array else {return}
            relationshipController.drop()
            for role in relationships {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                relationshipController.put(id: id, name: name)
            }
            return
        case .GetCountries:
            guard let countries = data["data"].array else {return}
            countryController.drop()
            for role in countries {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                guard let countryCode = role["country_code"].string else {continue}
                guard let countryCodeIso3 = role["country_code_iso3"].string else {continue}
                guard let enable = role["enable"].int else {continue}
                countryController.put(id: id, name: name, countryCode: countryCode, countryCodeIso3: countryCodeIso3, enable: enable)
            }
            return
        case .GetStates:
            stateController.drop()
            guard let states = data["data"].array else {return}
            for role in states {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                stateController.put(id: id, name: name)
            }
            return
        case .GetCities:
            cityController.drop()
            guard let cities = data["data"].array else {return}
            for role in cities {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                cityController.put(id: id, name: name)
            }
            return
        case .GetDistricts:
            districtController.drop()
            guard let districts = data["data"].array else {return}
            for role in districts {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                districtController.put(id: id, name: name)
            }
            return
        case .GetAreas:
            areaController.drop()
            guard let areas = data["data"].array else {return}
            for role in areas {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                areaController.put(id: id, name: name)
            }
            return
        case .GetProfileCustomer:
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
            guard let countryCode = data["data"]["customer_data"]["country_code"].string else {return}
            guard let stateId = data["data"]["customer_data"]["state_id"].int else {return}
            guard let cityId = data["data"]["customer_data"]["city_id"].int else {return}
            guard let districtId = data["data"]["customer_data"]["district_id"].int else {return}
            guard let areaId = data["data"]["customer_data"]["area_id"].int else {return}
            guard let zipCode = data["data"]["customer_data"]["zip_code"].string else {return}
            
            profileController.putCustomer(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone, roleId: roleId, createdAt: createdAt, updatedAt: updatedAt, uid: uid, photo: photo, address: address, countryCode: countryCode, stateId: stateId, cityId: cityId, districtId: districtId, areaId: areaId, zipCode: zipCode)
            
            pusherManager.startListening()
            return
        case .GetProfileFreelancer:
            guard let id = data["data"]["id"].int else {return}
            guard let firstName = data["data"]["first_name"].string else {return}
            guard let lastName = data["data"]["last_name"].string else {return}
            guard let email = data["data"]["email"].string else {return}
            guard let phone = data["data"]["phone"].string else {return}
            guard let roleId = data["data"]["role_id"].int else {return}
            guard let createdAt = data["data"]["created_at"].int else {return}
            guard let updatedAt = data["data"]["updated_at"].int else {return}
            guard let uid = data["data"]["freelancer_data"]["uid"].string else {return}
            guard let profession = data["data"]["freelancer_data"]["profession_id"].int else {return}
            guard let gender = data["data"]["freelancer_data"]["gender"].string else {return}
            guard let religion = data["data"]["freelancer_data"]["religion_id"].int else {return}
            guard let photo = data["data"]["freelancer_data"]["photo"].string else {return}
            guard let idCard = data["data"]["freelancer_data"]["id_card"].string else {return}
            guard let countryCode = data["data"]["freelancer_data"]["country_code"].string else {return}
            guard let packagePrice = data["data"]["freelancer_data"]["package_price"].int else {return}
            
            profileController.putFreelancer(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone, roleId: roleId, createdAt: createdAt, updatedAt: updatedAt, uid: uid, profession: profession, gender: gender, religion: religion, photo: photo, idCard: idCard, countryCode: countryCode, packagePrice: packagePrice)
            
            pusherManager.startListening()
            return
        case .Logout:
            profileController.drop()
            tokenController.drop()
            self.pusherManager.stopListening()
            return
        default:
            print("Unhandled \(code) on \(self.className)")
            return
        }
    }
    
}
