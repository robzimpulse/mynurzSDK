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

public class MynurzSDK: NSObject {

    public static let sharedInstance = MynurzSDK()
    let requestManager = RequestManager.sharedInstance
    let endpointManager = EndpointManager.sharedInstance
    let pusherManager = PusherManager.sharedInstance
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
    
    deinit {
        self.pusherManager.unsubscribeAll()
    }
    
    public func setDelegate(delegate: MynurzSDKDelegate){
        self.delegate = delegate
        self.requestManager.delegate = delegate
        self.pusherManager.delegate = delegate
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
    
    public func logout(){
        requestManager.request(method: .get, url: endpointManager.LOGOUT, parameters: nil, code: .Logout)
    }
    
    // MARK : - Customer Endpoint
    
    public func getProfile(){
        requestManager.request(method: .get, url: endpointManager.CUSTOMER_PROFILE, parameters: nil, code: .GetProfile)
    }
    
    public func updatePhoto(photo: UIImage){
        requestManager.request(url: endpointManager.CUSTOMER_PHOTO, image: photo, code: .UpdatePhoto, progressCode: .UpdatePhotoProgress)
    }
    
    public func updateSubscribe(status: Bool){
        let param = ["subscribe":status]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_SUBSCRIBE, parameters: param, code: .UpdateSubscribe)
    }
    
    public func updateAddress(address: String, country: Int, state: Int, city: Int, district: Int, zip: String){
        let param = ["address":address,"country":country.toString,"state":state.toString,"city":city.toString,"district":district.toString,"zip":zip]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_ADDRESS, parameters: param, code: .UpdateAddress)
    }
    
    public func updateName(firstname: String, lastname: String){
        let param = ["first_name":firstname, "last_name":lastname]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_NAME, parameters: param, code: .UpdateName)
    }
    
    public func updatePassword(password: String, passwordConfirmation: String){
        let param = ["password":password, "password_confirmation":passwordConfirmation]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_PASSWORD, parameters: param, code: .UpdatePassword)
    }
    
    public func updatePhone(mobilePhone: String){
        let param = ["mobile_phone":mobilePhone]
        requestManager.request(method: .post, url: endpointManager.CUSTOMER_PHONE, parameters: param, code: .UpdatePhone)
    }
    
    public func getPatient(){
        requestManager.request(method: .get, url: endpointManager.GET_CUSTOMER_PATIENT, parameters: nil, code: .GetPatient)
    }
    
    public func addPatient(name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo: UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString] as [String : Any]
        }
        requestManager.request(url: endpointManager.ADD_CUSTOMER_PATIENT, parameters: param, code: .AddPatient, progressCode: .AddPatientProgress)
    }
    
    public func updatePatient(withID id:Int, name:String, dob:String, gender: gender, weight: Double, height: Double, nationality:String, relationshipId:Int, photo:UIImage?){
        var param = [String:Any]()
        if let validPhoto = photo {
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"photo":validPhoto,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"id":id] as [String : Any]
        }else{
            param = ["name":name, "dob":dob, "gender": gender.rawValue, "weight":weight,"height":height, "nationality":nationality,"relationship_id":relationshipId.toString,"id":id] as [String : Any]
        }
        requestManager.request(url: endpointManager.UPDATE_CUSTOMER_PATIENT, parameters: param, code: .UpdatePatient, progressCode: .UpdatePatientProgress)
    }
    
    public func removePatient(patientId: Int){
        let param = ["id":patientId]
        requestManager.request(method: .post, url: endpointManager.REMOVE_CUSTOMER_PATIENT, parameters: param, code: .RemovePatient)
    }
    
}
