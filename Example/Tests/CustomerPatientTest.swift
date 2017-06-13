//
//  CustomerPatientTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class CustomerPatientTest: QuickSpec {
    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Customer-Patient endpoint") {
            
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("add patient with image") {
                self.sdk.addPatientCustomer(name: "patient2", dob: "1993-07-27", gender: .male, weight: 80.0, height: 175.0, nationality: "IDN", relationshipId: 2, photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.AddPatientCustomer), timeout: self.waitingTime)
            }
            
            it("update patient") {
                self.sdk.updatePatientCustomer(withID: 3, name: "kugelfang", dob: "1993-08-12", gender: .female, weight: 50.0, height: 180.0, nationality: "IDN", relationshipId: 4, photo: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePatientCustomer), timeout: self.waitingTime)
            }
            
            it("remove patient") {
                self.sdk.removePatientCustomer(patientId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.RemovePatientCustomer), timeout: self.waitingTime)
            }
        }
    }
}
