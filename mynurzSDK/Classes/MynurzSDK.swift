//
//  MynurzSDK.swift
//  Pods
//
//  Created by Robyarta on 5/15/17.
//
//

import Foundation
import RealmSwift
import Alamofire
import EZSwiftExtensions
import SwiftyJSON
import CoreLocation

public class MynurzSDK: NSObject {

    public static let sharedInstance = MynurzSDK()
    let requestManager = RequestManager.sharedInstance
    let endpointManager = EndpointManager.sharedInstance
    var reachablilityManager: NetworkReachabilityManager?
    var delegate: MynurzSDKDelegate?
    
    lazy var isTokenValid: Bool = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        guard let validToken = TokenController.sharedInstance.get() else {return false}
        guard let validDate = dateFormatter.date(from: validToken.tokenExpiredAt) else {return false}
        return validDate > Date()
    }()
    lazy var isTokenRefreshable: Bool = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        guard let validToken = TokenController.sharedInstance.get() else {return false}
        guard let validDate = dateFormatter.date(from: validToken.tokenLimitToRefresh) else {return false}
        return validDate > Date()
    }()
    
    public override init() {
        super.init()
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        guard let networkManager = NetworkReachabilityManager(host: endpointManager.cleanHost) else {
            print("Network manager not listening")
            return
        }
        
        networkManager.listener = { status in
            if let delegate = self.delegate {
                switch status {
                case .notReachable:
                    delegate.responseError(message: "Network Unreachable", code: .None, errorCode: .NoNetwork, data: nil)
                    return
                case .unknown:
                    delegate.responseError(message: "Network Unreachable", code: .None, errorCode: .NoNetwork, data: nil)
                    return
                default:
                    print("Unhandled \(status) on class \(self.className)")
                    return
                }
            }
        }
        
        networkManager.startListening()
        
        reachablilityManager = networkManager
    }
    
    public func setDelegate(delegate: MynurzSDKDelegate){
        self.delegate = delegate
        self.requestManager.delegate = delegate
        self.requestManager.dataManager.pusherManager.delegate = delegate
    }
    
    public func isUserOnline(userId: String) -> Bool{
        return self.requestManager.dataManager.pusherManager.isUserOnline(userId: userId)
    }
    
    public func updateLocation(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        self.requestManager.dataManager.pusherManager.updateLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK : - Public Endpoint
    
    public func login(email:String, password: String){
        let param = ["email": email, "password": password]
        requestManager.request(method: .post, url: endpointManager.LOGIN, parameters: param, code: .Login)
    }
    
    public func registerCustomer(firstname:String, lastname:String, email:String, password:String, passwordConfirmation:String, mobilePhone:String){
        let param = ["first_name":firstname, "last_name":lastname, "email":email, "password":password, "password_confirmation":passwordConfirmation, "mobile_phone":mobilePhone]
        requestManager.request(method: .post, url: endpointManager.REGISTER_CUSTOMER, parameters: param, code: .RegisterCustomer)
    }
    
    public func registerFreelancer(firstname:String, lastname:String, email:String, password:String, passwordConfirmation:String, mobilePhone:String){
        let param = ["first_name":firstname, "last_name":lastname, "email":email, "password":password, "password_confirmation":passwordConfirmation, "mobile_phone":mobilePhone]
        requestManager.request(method: .post, url: endpointManager.REGISTER_FREELANCER, parameters: param, code: .RegisterFreelancer)
    }
    
    public func resetLink(email: String){
        let param = ["email":email]
        requestManager.request(method: .post, url: endpointManager.RESET_LINK, parameters: param, code: .ResetLink)
    }
    
    public func logout(){
        requestManager.request(method: .get, url: endpointManager.LOGOUT, parameters: nil, code: .Logout)
    }
    
    // MARK : - Authenticated Endpoint
    
    public func setting(){
        requestManager.request(method: .get, url: endpointManager.SETTING, parameters: nil, code: .Setting)
    }
    
    public func getStates(countryId: Int){
        let url = endpointManager.GET_STATE + "?country_id=\(countryId)"
        requestManager.request(method: .get, url: url, parameters: nil, code: .GetStates)
    }
    
    public func getCities(stateId: Int){
        let url = endpointManager.GET_CITY + "?state_id=\(stateId)"
        requestManager.request(method: .get, url: url, parameters: nil, code: .GetCities)
    }
    
    public func getDistricts(cityId: Int){
        let url = endpointManager.GET_DISTRICT + "?city_id=\(cityId)"
        requestManager.request(method: .get, url: url, parameters: nil, code: .GetDistricts)
    }
    
    public func getAreas(districtId: Int){
        let url = endpointManager.GET_AREA + "?district_id=\(districtId)"
        requestManager.request(method: .get, url: url, parameters: nil, code: .GetAreas)
    }
    
    public func getFirebaseToken(){
        requestManager.request(method: .get, url: endpointManager.FIREBASE_TOKEN, parameters: nil, code: .GetFirebaseToken)
    }
    
    public func searchCustomer(uid: String?, email: String?, mobilePhone:String?){
        guard let token = TokenController.sharedInstance.get() else {return}
        var data = [String]()
        var url = ""
        if let validUid = uid {
            data.append("uid=\(validUid)")
        }
        if let validMobilePhone = mobilePhone {
            data.append("mobile_phone=\(validMobilePhone)")
        }
        if let validEmail = email {
            data.append("email=\(validEmail)")
        }
        
        if token.roleId == 2 {url.append(endpointManager.CUSTOMER_SEARCH_CUSTOMER)}
        else if token.roleId == 3 {url.append(endpointManager.FREELANCER_SEARCH_CUSTOMER)}
        url.append(data.joined(separator: "&"))
        requestManager.request(method: .get, url: url, parameters: nil, code: .SearchCustomer)
    }
    
    public func searchFreelancer(uid: String?, email: String?, mobilePhone:String?){
        guard let token = TokenController.sharedInstance.get() else {return}
        var data = [String]()
        var url = ""
        if let validUid = uid {
            data.append("uid=\(validUid)")
        }
        if let validMobilePhone = mobilePhone {
            data.append("mobile_phone=\(validMobilePhone)")
        }
        if let validEmail = email {
            data.append("email=\(validEmail)")
        }
        
        if token.roleId == 2 {url.append(endpointManager.CUSTOMER_SEARCH_FREELANCER)}
        else if token.roleId == 3 {url.append(endpointManager.FREELANCER_SEARCH_FREELANCER)}
        url.append(data.joined(separator: "&"))
        requestManager.request(method: .get, url: url, parameters: nil, code: .SearchFreelancer)
    }
    
    // MARK : - Freelancer Endpoint
    
    public func getProfileFreelancer(){
        requestManager.request(method: .get, url: endpointManager.FREELANCER_PROFILE, parameters: nil, code: .GetProfileFreelancer)
    }
    
    public func updatePhotoFreelancer(photo: UIImage){
        requestManager.request(url: endpointManager.FREELANCER_PHOTO, image: photo, code: .UpdatePhotoFreelancer, progressCode: .UpdatePhotoFreelancerProgress)
    }
    
    public func updateIDCardFreelancer(photo: UIImage){
        requestManager.request(url: endpointManager.FREELANCER_IDCARD, image: photo, code: .UpdateIDCardFreelancer, progressCode: .UpdateIDCardFreelancerProgress)
    }
    
    public func updatePackagePriceFreelancer(packagePrice: Int){
        let param = ["package_price":packagePrice]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PACKAGE_PRICE, parameters: param, code: .UpdatePackagePriceFreelancer)
    }
    
    public func updateProfileFreelancer(professionId: Int, gender: gender, religionId: Int, countryCode: String){
        let param = ["profession_id":professionId.toString,"gender":gender.rawValue,"religion_id":religionId.toString,"country_code":countryCode]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROFILE, parameters: param, code: .UpdateProfileFreelancer)
    }
    
    public func updateSubscribeFreelancer(status: Bool){
        let param = ["subscribe":status]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_SUBSCRIBE, parameters: param, code: .UpdateSubscribeFreelancer)
    }
    
    public func updateNameFreelancer(firstname: String, lastname: String){
        let param = ["first_name":firstname, "last_name":lastname]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_NAME, parameters: param, code: .UpdateNameFreelancer)
    }
    
    public func updatePasswordFreelancer(password: String, passwordConfirmation: String){
        let param = ["password":password, "password_confirmation":passwordConfirmation]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PASSWORD, parameters: param, code: .UpdatePasswordFreelancer)
    }
    
    public func updatePhoneFreelancer(mobilePhone: String){
        let param = ["mobile_phone":mobilePhone]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PHONE, parameters: param, code: .UpdatePhoneFreelancer)
    }
    
    public func updateAddressFreelancer(address: String, countryCode: String, stateId: Int, cityId: Int, districtId: Int, areaId: Int, zipCode: String){
        let param = ["address":address,"country_code":countryCode,"state_id":stateId.toString,"city_id":cityId.toString,"district_id":districtId.toString,"zip_code":zipCode,"area_id":areaId.toString]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_ADDRESS, parameters: param, code: .UpdateAddressFreelancer)
    }
    
    public func getAvailableInquiryFreelancer(){
        requestManager.request(method: .get, url: endpointManager.FREELANCER_INQUIRY_GET, parameters: nil, code: .GetAvailableInquiryFreelancer)
    }
    
    public func getAllProposalFreelancer(){
        requestManager.request(method: .get, url: endpointManager.FREELANCER_PROPOSAL_GET, parameters: nil, code: .GetAllProposalFreelancer)
    }
    
    public func addProposalFreelancer(inquiryId: Int, price: Int, fee: Int, description: String){
        let param = ["inquiry_id":inquiryId.toString,"price":price.toString,"fee":fee.toString,"description":description]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROPOSAL_ADD, parameters: param, code: .AddProposalFreelancer)
    }
    
    public func addCollaboratorProposalFreelancer(freelancerId: Int, proposalId: Int){
        let param = ["freelancer_id":freelancerId,"proposal_id":proposalId]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROPOSAL_COLLABORATOR_ADD, parameters: param, code: .AddCollaboratorProposalFreelancer)
    }
    
    public func removeCollaboratorProposalFreelancer(freelancerId: Int, proposalId: Int){
        let param = ["freelancer_id":freelancerId,"proposal_id":proposalId]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROPOSAL_COLLABORATOR_REMOVE, parameters: param, code: .RemoveCollaboratorProposalFreelancer)
    }
    
    public func updateProposalFreelancer(proposalId: Int, description: String, price: Int){
        let param = ["proposal_id":proposalId, "description":description, "price":price] as [String : Any]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROPOSAL_UPDATE, parameters: param, code: .UpdateProposalFreelancer)
    }
    
    public func submitProposalFreelancer(proposalId: Int){
        let param = ["proposal_id":proposalId]
        requestManager.request(method: .post, url: endpointManager.FREELANCER_PROPOSAL_SUBMIT, parameters: param, code: .SubmitProposalFreelancer)
    }
    
    // MARK : - Customer Endpoint
    
    public func getProfileCustomer(){
        requestManager.request(method: .get, url: endpointManager.CUSTOMER_PROFILE, parameters: nil, code: .GetProfileCustomer)
    }
    
    public func updatePhotoCustomer(photo: UIImage){
        requestManager.request(url: endpointManager.CUSTOMER_PHOTO, image: photo, code: .UpdatePhotoCustomer, progressCode: .UpdatePhotoCustomerProgress)
    }
    
    public func updateSubscribeCustomer(status: Bool){
        let param = ["subscribe":status]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_SUBSCRIBE, parameters: param, code: .UpdateSubscribeCustomer)
    }
    
    public func updateAddressCustomer(address: String, countryCode: String, stateId: Int, cityId: Int, districtId: Int, areaId: Int, zipCode: String){
        let param = ["address":address,"country_code":countryCode,"state_id":stateId.toString,"city_id":cityId.toString,"district_id":districtId.toString,"zip_code":zipCode,"area_id":areaId.toString]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_ADDRESS, parameters: param, code: .UpdateAddressCustomer)
    }
    
    public func updateNameCustomer(firstname: String, lastname: String){
        let param = ["first_name":firstname, "last_name":lastname]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_NAME, parameters: param, code: .UpdateNameCustomer)
    }
    
    public func updatePasswordCustomer(password: String, passwordConfirmation: String){
        let param = ["password":password, "password_confirmation":passwordConfirmation]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_PASSWORD, parameters: param, code: .UpdatePasswordCustomer)
    }
    
    public func updatePhoneCustomer(mobilePhone: String){
        let param = ["mobile_phone":mobilePhone]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_PHONE, parameters: param, code: .UpdatePhoneCustomer)
    }
    
    public func getPatientCustomer(){
        requestManager.request(method: .get, url: endpointManager.CUSTOMER_PATIENT_GET, parameters: nil, code: .GetPatientCustomer)
    }
    
    public func addPatientCustomer(name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo: UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }
        requestManager.request(url: endpointManager.CUSTOMER_PATIENT_ADD, parameters: param, code: .AddPatientCustomer, progressCode: .AddPatientCustomerProgress)
    }
    
    public func updatePatientCustomer(withID id:Int, name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo:UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"patient_id":id] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"patient_id":id] as [String : Any]
        }
        requestManager.request(url: endpointManager.CUSTOMER_PATIENT_UPDATE, parameters: param, code: .UpdatePatientCustomer, progressCode: .UpdatePatientCustomerProgress)
    }
    
    public func removePatientCustomer(patientId: Int){
        let param = ["patient_id":patientId]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_PATIENT_REMOVE, parameters: param, code: .RemovePatientCustomer)
    }
    
    public func getInquiryCustomer(){
        requestManager.request(method: .get, url: endpointManager.CUSTOMER_INQUIRY_GET, parameters: nil, code: .GetInquiryCustomer)
    }
    
    public func addInquiryCustomer(patientId: Int, patientCondition: String, address: String, countryCode: String, stateId: Int, areaId: Int, districtId: Int, cityId: Int, zipCode: String, professionId: Int, gender: gender, startDate: Date, endDate: Date, jobDetail: String){
        let param = ["patient_id":patientId,"patient_condition":patientCondition,"address":address,"country_code":countryCode,"state_id":stateId,"area_id":areaId,"district_id":districtId,"city_id":cityId,"zip_code":zipCode,"profession_id":professionId,"gender":gender.rawValue,"start_date":startDate.toString(format: "yyyy-MM-dd"),"end_date":endDate.toString(format: "yyyy-MM-dd"),"job_detail":jobDetail] as [String : Any]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_INQUIRY_ADD, parameters: param, code: .AddInquiryCustomer)
    }

    public func updateInquiryCustomer(inquiryId: Int,patientId: Int, patientCondition: String, address: String, countryCode: String, stateId: Int, areaId: Int, districtId: Int, cityId: Int, zipCode: String, professionId: Int, gender: gender, startDate: Date, endDate: Date, jobDetail: String){
        let param = ["inquiry_id":inquiryId,"patient_id":patientId,"patient_condition":patientCondition,"address":address,"country_code":countryCode,"state_id":stateId,"area_id":areaId,"district_id":districtId,"city_id":cityId,"zip_code":zipCode,"profession_id":professionId,"gender":gender.rawValue,"start_date":startDate.toString(format: "yyyy-MM-dd"),"end_date":endDate.toString(format: "yyyy-MM-dd"),"job_detail":jobDetail] as [String : Any]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_INQUIRY_UPDATE, parameters: param, code: .UpdateInquiryCustomer)
    }
    
    public func publishInquiryCustomer(inquiryId: Int){
        let param = ["inquiry_id":inquiryId]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_INQUIRY_PUBLISH, parameters: param, code: .PublishInquiryCustomer)
    }
    
}
