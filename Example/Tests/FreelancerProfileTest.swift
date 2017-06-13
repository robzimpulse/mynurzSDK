//
//  FreelancerProfileTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class FreelancerProfileTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Freelancer-Profile endpoint") {
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "freelancer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
            it("get profile") {
                self.sdk.getProfileFreelancer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetProfileFreelancer), timeout: self.waitingTime)
            }
            
            it("update photo") {
                self.sdk.updatePhotoFreelancer(photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhotoFreelancer), timeout: self.waitingTime)
            }
            
            it("update id card") {
                self.sdk.updateIDCardFreelancer(photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateIDCardFreelancer), timeout: self.waitingTime)
            }
            
            it("update profile") {
                self.sdk.updateProfileFreelancer(professionId: 1, gender: .male, religionId: 2, countryCode: "IDN")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateProfileFreelancer), timeout: self.waitingTime)
            }
            
            it("update subscribe") {
                self.sdk.updateSubscribeFreelancer(status: true)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateSubscribeFreelancer), timeout: self.waitingTime)
            }
            
            it("update package price") {
                self.sdk.updatePackagePriceFreelancer(packagePrice: 350000)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePackagePriceFreelancer), timeout: self.waitingTime)
            }
            
            it("update name") {
                self.sdk.updateNameFreelancer(firstname: "freelancer", lastname: "testing")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateNameFreelancer), timeout: self.waitingTime)
            }
            
            it("update password") {
                self.sdk.updatePasswordFreelancer(password: "111111", passwordConfirmation: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePasswordFreelancer), timeout: self.waitingTime)
            }
            
            it("update phone") {
                self.sdk.updatePhoneFreelancer(mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhoneFreelancer), timeout: self.waitingTime)
            }
            
            it("update address") {
                self.sdk.updateAddressFreelancer(address: "test address", countryCode: "IDN", stateId: 6728, cityId: 269, districtId: 9, areaId: 10, zipCode: "12345")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateAddressFreelancer), timeout: self.waitingTime)
            }
            
            it("update nationality") {
                self.sdk.updateNationalityFreelancer(nationality: "IDN")
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateNationalityFreelancer), timeout: self.waitingTime)
            }
            
        }
    }
    
}
