//
//  AuthTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 5/10/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK


class AuthTest: QuickSpec {

    override func spec() {
        
        let sdk = MynurzSDK.local
        let mock = MockSDK()
        sdk.delegate = mock
        
        describe("Customer & Freelancer Authentication") {
            
            it("register customer") {
                sdk.registerCustomer(
                    firstName: "user",
                    lastName: "customer",
                    email: "customer@example.org",
                    password: "kiasu123",
                    passwordConfirmation: "kiasu123",
                    mobilePhone: "+6281222542156"
                )
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.RegisterCustomer), timeout: 30.0)
            }
            
            it("register freelancer") {
                
                sdk.registerFreelancer(
                    firstName: "user",
                    lastName: "freelancer",
                    email: "freelancer@example.org",
                    password: "kiasu123",
                    passwordConfirmation: "kiasu123",
                    mobilePhone: "+6281553353089"
                )
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.RegisterFreelancer), timeout: 30.0)
            }
        }
    }
    
}
