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
    let waitingTime = 30.0
    
    override func spec() {
        
        self.sdk.setDelegate(delegate: mock)
        
        describe("Public endpoint") {
            
            it("login") {
                self.sdk.login(email: "kugelfang.killaruna@gmail.com", password: "kiasu123")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            it("register") {
                self.sdk.registerCustomer(firstname: "kugelfang", lastname: "killaruna", email: "kugelfang.killaruna@gmail.com", password: "kiasu123", passwordConfirmation: "kiasu123", mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterCustomer), timeout: self.waitingTime)
            }
            
            it("reset link"){
                self.sdk.resetLink(email: "kugelfang.killaruna@gmail.com")
                expect(self.mock.code).toEventually(equal(RequestCode.ResetLink), timeout: self.waitingTime)
            }
            
            it("logout"){
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
        }
        describe("Customer endpoint") {
            
            beforeEach {
                self.sdk.login(email: "kugelfang.killaruna@gmail.com", password: "kiasu123")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("setting"){
                self.sdk.setting()
                expect(self.mock.code).toEventually(equal(RequestCode.Setting), timeout: self.waitingTime)
            }
        }
    }
}

