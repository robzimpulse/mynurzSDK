//
//  BasicTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 5/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class BasicTest: QuickSpec {
    
    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        self.sdk.setDelegate(delegate: mock)
        
        describe("Public endpoint") {
            
            it("login") {
                self.sdk.login(email: "customer@example.com", password: "kiasu123")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            it("register") {
                self.sdk.registerCustomer(firstname: "kugelfang", lastname: "killaruna", email: "kugelfang.killaruna@gmail.com", password: "kiasu123", passwordConfirmation: "kiasu123", mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterCustomer), timeout: self.waitingTime)
            }
            
            it("reset link"){
                self.sdk.resetLink(email: "customer@example.com")
                expect(self.mock.code).toEventually(equal(RequestCode.ResetLink), timeout: self.waitingTime)
            }
            
            it("logout"){
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
        }
        describe("Customer endpoint") {
            
            beforeEach {
                self.sdk.login(email: "customer@example.com", password: "kiasu123")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("get states") {
                self.sdk.getStates(countryId: 100)
                expect(self.mock.code).toEventually(equal(RequestCode.GetStates), timeout: self.waitingTime)
            }
            
            it("get cities") {
                self.sdk.getCities(stateId: 10)
                expect(self.mock.code).toEventually(equal(RequestCode.GetCities), timeout: self.waitingTime)
            }
            
            it("get districts") {
                self.sdk.getDistricts(cityId: 10)
                expect(self.mock.code).toEventually(equal(RequestCode.GetDistricts), timeout: self.waitingTime)
            }
            
            it("get areas") {
                self.sdk.getAreas(districtId: 10)
                expect(self.mock.code).toEventually(equal(RequestCode.GetAreas), timeout: self.waitingTime)
            }
            
            it("get setting") {
                self.sdk.setting()
                expect(self.mock.code).toEventually(equal(RequestCode.Setting), timeout: self.waitingTime)
            }
            
            it("get profile") {
                self.sdk.getProfile()
                expect(self.mock.code).toEventually(equal(RequestCode.GetProfile), timeout: self.waitingTime)
            }
            
            it("update photo") {
                self.sdk.updatePhoto(photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhoto), timeout: self.waitingTime)
            }
            
            it("update subscription status") {
                self.sdk.updateSubscribe(status: true)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateSubscribe), timeout: self.waitingTime)
            }
            
            it("update address") {
                self.sdk.updateAddress(address: "new address", country: 1, state: 1, city: 1, district: 1, zip: "60285")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateAddress), timeout: self.waitingTime)
            }
            
            it("update name") {
                self.sdk.updateName(firstname: "kugelfang", lastname: "killaruna")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateName), timeout: self.waitingTime)
            }
            
            it("update password") {
                self.sdk.updatePassword(password: "kiasu123", passwordConfirmation: "kiasu123")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePassword), timeout: self.waitingTime)
            }
            
            it("update phone") {
                self.sdk.updatePhone(mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhone), timeout: self.waitingTime)
            }
            
        }
    }
}

