//
//  CustomerSetting.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class CustomerProfileTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Customer-Profile endpoint") {
            
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("get profile") {
                self.sdk.getProfileCustomer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetProfileCustomer), timeout: self.waitingTime)
            }
            
            it("update photo") {
                self.sdk.updatePhotoCustomer(photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhotoCustomer), timeout: self.waitingTime)
            }
            
            it("update nationality") {
                self.sdk.updateNationalityCustomer(nationality: "IDN")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateNationalityCustomer), timeout: self.waitingTime)
            }
            
            it("update subscription status") {
                self.sdk.updateSubscribeCustomer(status: true)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateSubscribeCustomer), timeout: self.waitingTime)
            }
            
            it("update address") {
                self.sdk.updateAddressCustomer(address: "new address", countryCode: "IDN", stateId: 6728, cityId: 269, districtId: 9, areaId: 10, zipCode: "12345")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateAddressCustomer), timeout: self.waitingTime)
            }
            
            it("update name") {
                self.sdk.updateNameCustomer(firstname: "kugelfang", lastname: "killaruna")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateNameCustomer), timeout: self.waitingTime)
            }
            
            it("update password") {
                self.sdk.updatePasswordCustomer(password: "111111", passwordConfirmation: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePasswordCustomer), timeout: self.waitingTime)
            }
            
            it("update phone") {
                self.sdk.updatePhoneCustomer(mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhoneCustomer), timeout: self.waitingTime)
            }
            
        }
        
    }
    
}
