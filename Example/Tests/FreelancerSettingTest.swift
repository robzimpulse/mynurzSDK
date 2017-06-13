//
//  FreelancerSettingTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class FreelancerSettingTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {

        describe("Freelancer-Setting endpoint") {
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "freelancer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("search specific freelancer") {
                self.sdk.searchFreelancer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchFreelancer), timeout: self.waitingTime)
            }
            
            it("search specific customer") {
                self.sdk.searchCustomer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchCustomer), timeout: self.waitingTime)
            }
            
            it("get skills") {
                self.sdk.getSkill()
                expect(self.mock.code).toEventually(equal(RequestCode.GetSkills), timeout: self.waitingTime)
            }
            
            it("get skill experiences") {
                self.sdk.getSkillExperience()
                expect(self.mock.code).toEventually(equal(RequestCode.GetSkillExperiences), timeout: self.waitingTime)
            }
            
            it("get roles") {
                self.sdk.getRole()
                expect(self.mock.code).toEventually(equal(RequestCode.GetRoles), timeout: self.waitingTime)
            }
            
            it("get religions") {
                self.sdk.getReligion()
                expect(self.mock.code).toEventually(equal(RequestCode.GetReligions), timeout: self.waitingTime)
            }
            
            it("get promotion categories") {
                self.sdk.getPromotionCategory()
                expect(self.mock.code).toEventually(equal(RequestCode.GetPromotionCategories), timeout: self.waitingTime)
            }
            
            it("get professions") {
                self.sdk.getProfession()
                expect(self.mock.code).toEventually(equal(RequestCode.GetProfessions), timeout: self.waitingTime)
            }
            
            it("get job statuses") {
                self.sdk.getJobStatus()
                expect(self.mock.code).toEventually(equal(RequestCode.GetJobStatuses), timeout: self.waitingTime)
            }
            
            it("get employments") {
                self.sdk.getEmployment()
                expect(self.mock.code).toEventually(equal(RequestCode.GetEmployments), timeout: self.waitingTime)
            }
            
            it("get degrees") {
                self.sdk.getDegree()
                expect(self.mock.code).toEventually(equal(RequestCode.GetDegrees), timeout: self.waitingTime)
            }
            
            it("get relationships") {
                self.sdk.getRelationship()
                expect(self.mock.code).toEventually(equal(RequestCode.GetRelationships), timeout: self.waitingTime)
            }
            
            it("get countries") {
                self.sdk.getCountry()
                expect(self.mock.code).toEventually(equal(RequestCode.GetCountries), timeout: self.waitingTime)
            }
            
            it("get states") {
                self.sdk.getStates(countryId: 100)
                expect(self.mock.code).toEventually(equal(RequestCode.GetStates), timeout: self.waitingTime)
            }
            
            it("get cities") {
                self.sdk.getCities(stateId: 6728)
                expect(self.mock.code).toEventually(equal(RequestCode.GetCities), timeout: self.waitingTime)
            }
            
            it("get districts") {
                self.sdk.getDistricts(cityId: 269)
                expect(self.mock.code).toEventually(equal(RequestCode.GetDistricts), timeout: self.waitingTime)
            }
            
            it("get areas") {
                self.sdk.getAreas(districtId: 9)
                expect(self.mock.code).toEventually(equal(RequestCode.GetAreas), timeout: self.waitingTime)
            }
        }
        
    }
    
}
