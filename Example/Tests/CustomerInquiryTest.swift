//
//  CustomerTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class CustomerInquiryTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Customer-Inquiry endpoint") {
            
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("get all submitted inquiry") {
                self.sdk.getInquiryCustomer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetInquiryCustomer), timeout: self.waitingTime)
            }
            
            it("add inquiry") {
                self.sdk.addInquiryCustomer(patientId: 1, patientCondition: "patient condition", address: "jalan kebon jeruk", countryCode: "IDN", stateId: 6728, areaId: 4, districtId: 9, cityId: 269, zipCode: "12345", professionId: 1, gender: .male, startDate: Date(), endDate: Date(), jobDetail: "detail job")
                expect(self.mock.code).toEventually(equal(RequestCode.AddInquiryCustomer), timeout: self.waitingTime)
            }
            
            it("update inquiry") {
                self.sdk.updateInquiryCustomer(inquiryId: 1, patientId: 1, patientCondition: "patient condition", address: "jalan kebon jeruk", countryCode: "IDN", stateId: 6728, areaId: 4, districtId: 9, cityId: 269, zipCode: "12345", professionId: 1, gender: .male, startDate: Date(), endDate: Date(), jobDetail: "detail job")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateInquiryCustomer), timeout: self.waitingTime)
            }
            
            it("publish inquiry") {
                self.sdk.publishInquiryCustomer(inquiryId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.PublishInquiryCustomer), timeout: self.waitingTime)
            }
            
        }
    }
    
}
