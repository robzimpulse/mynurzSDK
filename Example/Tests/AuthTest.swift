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

class AuthTest: QuickSpec {
    
    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Authentication endpoint") {
            
            it("login") {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            it("register customer") {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.registerCustomer(firstname: "kugelfang", lastname: "killaruna", email: "customer@kronusasia.com", password: "111111", passwordConfirmation: "111111", mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterCustomer), timeout: self.waitingTime)
            }
            
            it("register freelancer") {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.registerFreelancer(firstname: "freelancer", lastname: "register", email: "freelancer@kronusasia.com", password: "111111", passwordConfirmation: "111111", mobilePhone: "+6281222542155", professionId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterFreelancer), timeout: self.waitingTime)
            }
            
            it("reset link"){
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.resetLink(email: "customer@kronusasia.com")
                expect(self.mock.code).toEventually(equal(RequestCode.ResetLink), timeout: self.waitingTime)
            }
            
            it("logout"){
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
        }
    }
}

