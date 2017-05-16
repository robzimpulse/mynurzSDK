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
    }
    
    // MARK : - Customer endpoint
    
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
    
    public func logout(){
        requestManager.request(method: .get, url: endpointManager.LOGOUT, parameters: nil, code: .Logout)
    }
    
}
