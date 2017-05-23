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
        guard let validToken = TokenController.sharedInstance.get() else {return false}
        return validToken.tokenExpiredAt > Date().timeIntervalSince1970.toInt
    }()
    lazy var isTokenRefreshable: Bool = {
        guard let validToken = TokenController.sharedInstance.get() else {return false}
        return validToken.tokenLimitToRefresh > Date().timeIntervalSince1970.toInt
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
        requestManager.request(method: .get, url: endpointManager.GET_CUSTOMER_PATIENT, parameters: nil, code: .GetPatientCustomer)
    }
    
    public func addPatientCustomer(name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo: UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }
        requestManager.request(url: endpointManager.ADD_CUSTOMER_PATIENT, parameters: param, code: .AddPatientCustomer, progressCode: .AddPatientCustomerProgress)
    }
    
    public func updatePatientCustomer(withID id:Int, name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo:UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"id":id] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"id":id] as [String : Any]
        }
        requestManager.request(url: endpointManager.UPDATE_CUSTOMER_PATIENT, parameters: param, code: .UpdatePatientCustomer, progressCode: .UpdatePatientCustomerProgress)
    }
    
    public func removePatientCustomer(patientId: Int){
        let param = ["id":patientId]
        requestManager.request(method: .post, url: endpointManager.REMOVE_CUSTOMER_PATIENT, parameters: param, code: .RemovePatientCustomer)
    }
    
}
