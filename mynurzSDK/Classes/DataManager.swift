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
            guard let states = data["data"]["states"].array else {return}
            guard let skills = data["data"]["skills"].array else {return}
            guard let roles = data["data"]["roles"].array else {return}
            guard let professions = data["data"]["professions"].array else {return}
            guard let jobStatuses = data["data"]["job_statuses"].array else {return}
            guard let countries = data["data"]["countries"].array else {return}
            guard let cities = data["data"]["cities"].array else {return}
            guard let promotionCategories = data["data"]["promotion_categories"].array else {return}
            guard let skillExperiences = data["data"]["skill_experiences"].array else {return}
            guard let religions = data["data"]["religions"].array else {return}
            guard let districts = data["data"]["districts"].array else {return}
            guard let employments = data["data"]["employments"].array else {return}
            guard let areas = data["data"]["areas"].array else {return}
            guard let degrees = data["data"]["degrees"].array else {return}
            
            profileController.drop()
            
            for state in states {
                guard let id = state["id"].int else {continue}
                guard let name = state["name"].string else {continue}
                profileController.put(stateWithId: id, name: name)
            }
            
            for skill in skills {
                guard let id = skill["id"].int else {continue}
                guard let name = skill["name"].string else {continue}
                profileController.put(skillWithId: id, name: name)
            }
            
            for role in roles {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in professions {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in jobStatuses {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in countries {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in cities {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in promotionCategories {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in skillExperiences {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in employments {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for religion in religions {
                guard let id = religion["id"].int else {continue}
                guard let name = religion["name"].string else {continue}
                profileController.put(religionWithId: id, name: name)
            }
            
            for role in districts {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in areas {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            
            for role in degrees {
                guard let id = role["id"].int else {continue}
                guard let name = role["name"].string else {continue}
                profileController.put(roleWithId: id, name: name)
            }
            return
        case .Logout:
            profileController.drop()
            tokenController.drop()
            return
        default:
            print("Unhandled \(code) on \(self.className)")
            print(data)
            return
        }
    }
    
}
