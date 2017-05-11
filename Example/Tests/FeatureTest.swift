//
//  CustomerFeatureTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 5/5/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK

class FeatureTest: QuickSpec {
    
    override func spec() {
        
        let sdk = MynurzSDK.local
        let mock = MockSDK()
        let waitingTime = 5.0
        sdk.delegate = mock
        
        describe("customer only feature testing") {
            beforeEach {
                sdk.login(email: "customer@example.org", password: "kiasu123")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.Login), timeout: waitingTime)
            }
            
            afterEach {
                sdk.logout()
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.Logout), timeout: waitingTime)
            }
            
            it("update photo profile") {
                sdk.updatePhotoProfileCustomer(photo: UIImage.blankImage())
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateCustomerPhotoProfile), timeout: waitingTime)
            }
            
            it("update subscription status") {
                sdk.updateSubscriptionCustomer(status: true)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateCustomerSubscription), timeout: waitingTime)
            }
            
            it("update address") {
                sdk.updateAddressCustomer(address: "my address", zip: "60212", district: 1, city: 1, state: 1, country: 1)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateCustomerAddress), timeout: waitingTime)
            }
            
            it("update user name") {
                sdk.updateName(firstname: "Update", lastname: "Name")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateName), timeout: waitingTime)
            }
            
            it("update user phone") {
                sdk.updatePhone(phone: "+6281553353089")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdatePhone), timeout: waitingTime)
            }
            
            it("update user password") {
                sdk.updatePassword(password: "kiasu123", confirmPassword: "kiasu123")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdatePassword), timeout: waitingTime)
            }
            
            it("get user profile") {
                sdk.getProfile()
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.GetProfile), timeout: waitingTime)
            }

        }
        
        describe("freelancer only feature testing") {
            beforeEach {
                sdk.login(email: "freelancer@example.org", password: "kiasu123")
//                print(mock.lastCode as Any)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.Login), timeout: waitingTime)
            }
            
            afterEach {
                sdk.logout()
//                print(mock.lastCode as Any)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.Logout), timeout: waitingTime)
            }
            
            it("update photo profile") {
                sdk.updatePhotoProfileFreelancer(photo: UIImage.blankImage())
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateFreelancerPhotoProfile), timeout: waitingTime)
            }
            
            it("update photo id card") {
                sdk.updatePhotoIDCardFreelancer(photo: UIImage.blankImage())
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateFreelancerIDCard), timeout: waitingTime)
            }
            
            it("update package price") {
                sdk.updatePackagePriceFreelancer(packagePrice: 300000)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateFreelancerPackagePrice), timeout: waitingTime)
            }
            
            it("update profile") {
                sdk.updateProfileFreelancer(profession: 1, gender: "male", religion: 1, countryCode: "IDN")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateFreelancerProfile), timeout: waitingTime)
            }
            
            it("update subscription status") {
                sdk.updateSubscriptionFreelancer(status: true)
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateFreelancerSubscription), timeout: waitingTime)
            }
            
            it("update user name") {
                sdk.updateName(firstname: "Update", lastname: "Name")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdateName), timeout: waitingTime)
            }
            
            it("update user phone") {
                sdk.updatePhone(phone: "+6281553353089")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdatePhone), timeout: waitingTime)
            }
            
            it("update user password") {
                sdk.updatePassword(password: "kiasu123", confirmPassword: "kiasu123")
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.UpdatePassword), timeout: waitingTime)
            }
            
            it("get user profile") {
                sdk.getProfile()
                expect(mock.lastCode).toEventually(equal(MynurzSDKRequestCode.GetProfile), timeout: waitingTime)
            }

        }
    }
}

