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
        
        describe("Customer endpoint") {
            
            beforeEach {
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
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
                self.sdk.getCities(stateId: 6728)
                expect(self.mock.code).toEventually(equal(RequestCode.GetCities), timeout: self.waitingTime)
            }
            
            it("get districts") {
                self.sdk.getDistricts(cityId: 269)
                expect(self.mock.code).toEventually(equal(RequestCode.GetDistricts), timeout: self.waitingTime)
            }
            
            it("get areas") {
                self.sdk.getAreas(districtId: 9)
                expect(self.mock.code).toEventually(equal(RequestCode.GetAreas), timeout: self.waitingTime)
            }
            
            it("get setting") {
                self.sdk.setting()
                expect(self.mock.code).toEventually(equal(RequestCode.Setting), timeout: self.waitingTime)
            }
            
            it("get profile") {
                self.sdk.getProfileCustomer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetProfileCustomer), timeout: self.waitingTime)
            }
            
            it("update photo") {
                self.sdk.updatePhotoCustomer(photo: UIImage.blankImage())
                expect(self.mock.code).toEventually(equal(RequestCode.UpdatePhotoCustomer), timeout: self.waitingTime)
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
            
            it("search specific freelancer") {
                self.sdk.searchFreelancer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchFreelancer), timeout: self.waitingTime)
            }
            
            it("search specific customer") {
                self.sdk.searchCustomer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchCustomer), timeout: self.waitingTime)
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
            
        }
        
        describe("Freelancer endpoint") {
            beforeEach {
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
            
            it("get states") {
                self.sdk.getStates(countryId: 100)
                expect(self.mock.code).toEventually(equal(RequestCode.GetStates), timeout: self.waitingTime)
            }
            
            it("get cities") {
                self.sdk.getCities(stateId: 6728)
                expect(self.mock.code).toEventually(equal(RequestCode.GetCities), timeout: self.waitingTime)
            }
            
            it("get districts") {
                self.sdk.getDistricts(cityId: 269)
                expect(self.mock.code).toEventually(equal(RequestCode.GetDistricts), timeout: self.waitingTime)
            }
            
            it("get areas") {
                self.sdk.getAreas(districtId: 9)
                expect(self.mock.code).toEventually(equal(RequestCode.GetAreas), timeout: self.waitingTime)
            }
            
            it("get setting") {
                self.sdk.setting()
                expect(self.mock.code).toEventually(equal(RequestCode.Setting), timeout: self.waitingTime)
            }
            
            it("search specific freelancer") {
                self.sdk.searchFreelancer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchFreelancer), timeout: self.waitingTime)
            }
            
            it("search specific customer") {
                self.sdk.searchCustomer(uid: nil, email: nil, mobilePhone: nil)
                expect(self.mock.code).toEventually(equal(RequestCode.SearchCustomer), timeout: self.waitingTime)
            }
            
            it("get all available inquiries") {
                self.sdk.getAvailableInquiryFreelancer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetAvailableInquiryFreelancer), timeout: self.waitingTime)
            }
            
            it("get all submitted proposal") {
                self.sdk.getAllProposalFreelancer()
                expect(self.mock.code).toEventually(equal(RequestCode.GetAllProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("add proposal") {
                self.sdk.addProposalFreelancer(inquiryId: 1, price: 100000, fee: 150000, description: "kugelfang killaruna")
                expect(self.mock.code).toEventually(equal(RequestCode.AddProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("add collaborator to specific proposal") {
                self.sdk.addCollaboratorProposalFreelancer(freelancerId: 1, proposalId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.AddCollaboratorProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("remove collaborator from specific proposal") {
                self.sdk.removeCollaboratorProposalFreelancer(freelancerId: 1, proposalId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.RemoveCollaboratorProposalFreelancer), timeout: self.waitingTime)
            }
            
        }
        
        describe("Public endpoint") {
            
            it("login") {
                self.sdk.login(email: "customer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            it("register customer") {
                self.sdk.registerCustomer(firstname: "kugelfang", lastname: "killaruna", email: "customer@kronusasia.com", password: "111111", passwordConfirmation: "111111", mobilePhone: "+6281222542156")
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterCustomer), timeout: self.waitingTime)
            }
            
            it("register freelancer") {
                self.sdk.registerFreelancer(firstname: "freelancer", lastname: "register", email: "freelancer@kronusasia.com", password: "111111", passwordConfirmation: "111111", mobilePhone: "+6281222542155")
                expect(self.mock.code).toEventually(equal(RequestCode.RegisterFreelancer), timeout: self.waitingTime)
            }
            
            it("reset link"){
                self.sdk.resetLink(email: "customer@kronusasia.com")
                expect(self.mock.code).toEventually(equal(RequestCode.ResetLink), timeout: self.waitingTime)
            }
            
            it("logout"){
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
            }
            
        }
    }
}

