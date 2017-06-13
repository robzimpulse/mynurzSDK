//
//  FreelancerLicenseTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class FreelancerLicenseTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Freelancer-License endpoint") {
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "freelancer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("get all licenses") {
                
            }
            
            it("add license") {
                
            }
            
            it("update license") {
                
            }
            
            it("remove license") {
                
            }

            
        }
    }
    
}
