//
//  FreelancerTest.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import mynurzSDK
import SwiftyJSON

class FreelancerProposalTest: QuickSpec {

    let sdk = MynurzSDK.sharedInstance
    let mock = Mock()
    let waitingTime = 60.0
    
    override func spec() {
        
        describe("Freelancer endpoint") {
            beforeEach {
                self.sdk.setDelegate(delegate: self.mock)
                self.sdk.login(email: "freelancer@kronusasia.com", password: "111111")
                expect(self.mock.code).toEventually(equal(RequestCode.Login), timeout: self.waitingTime)
            }
            
            afterEach {
                self.sdk.logout()
                expect(self.mock.code).toEventually(equal(RequestCode.Logout), timeout: self.waitingTime)
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
            
            it("update proposal") {
                self.sdk.updateProposalFreelancer(proposalId: 1, description: "this is description", price: 350000)
                expect(self.mock.code).toEventually(equal(RequestCode.UpdateProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("add collaborator to specific proposal") {
                self.sdk.addCollaboratorProposalFreelancer(freelancerId: 1, proposalId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.AddCollaboratorProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("remove collaborator from specific proposal") {
                self.sdk.removeCollaboratorProposalFreelancer(freelancerId: 1, proposalId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.RemoveCollaboratorProposalFreelancer), timeout: self.waitingTime)
            }
            
            it("submit proposal") {
                self.sdk.submitProposalFreelancer(proposalId: 1)
                expect(self.mock.code).toEventually(equal(RequestCode.SubmitProposalFreelancer), timeout: self.waitingTime)
            }
            
        }
    }
}
