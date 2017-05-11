//
//  MynurzSDK.swift
//  Pods
//
//  Created by Robyarta on 5/5/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import EZSwiftExtensions
import CoreLocation
import RealmSwift

public class MynurzSDK: NSObject, CLLocationManagerDelegate{

    public var reachablilityManager: NetworkReachabilityManager?
    public var delegate: MynurzSDKDelegate?
    public static let local = MynurzSDK(state: .Local)
    public static let staging = MynurzSDK(state: .Staging)
    public static let live = MynurzSDK(state: .Live)
    public dynamic var autoUpdateMap = false
    
    private var context = 0
    private var locManager = CLLocationManager()
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var timer: Timer?
    
    var API_URL_HOST = "http://mynurznew.app"
    let API_LOGIN = "/api/login"
    let API_FORGET_PASSWORD = "/api/reset"
    let API_UPDATE_LOCATION = "/api/update_location"
    let API_UPDATE_ONLINE_STATE = "/api/update_online_state"
    let API_LOGOUT = "/api/logout"
    let API_REFRESH_TOKEN = "/api/refresh_token"
    let API_PROFILE = "/api/profile"
    let API_UPDATE_USER_NAME = "/api/update_name"
    let API_UPDATE_USER_PASSWORD = "/api/update_password"
    let API_UPDATE_USER_PHONE = "/api/update_phone"
    
    let API_CUSTOMER_REGISTER = "/api/register_customer"
    let API_CUSTOMER_UPDATE_PHOTO_PROFILE = "/api/customer/update_photo"
    let API_CUSTOMER_UPDATE_SUBSCRIBE = "/api/customer/update_subscribe"
    let API_CUSTOMER_UPDATE_ADDRESS = "/api/customer/update_address"
    
    let API_FREELANCER_REGISTER = "/api/register_freelancer"
    let API_FREELANCER_UPDATE_PHOTO_PROFILE = "/api/freelancer/update_photo"
    let API_FREELANCER_UPDATE_SUBSCRIBE = "/api/freelancer/update_subscribe"
    let API_FREELANCER_UPDATE_PHOTO_ID_CARD = "/api/freelancer/update_id_card"
    let API_FREELANCER_UPDATE_PROFILE = "/api/freelancer/update_profile"
    let API_FREELANCER_UPDATE_PACKAGE_PRICE = "/api/freelancer/update_package_price"
    
    lazy var debouncedOnlineState : Debouncer = {
        return Debouncer(delay: 0.2, callback: {
            let urlString = self.API_URL_HOST + self.API_UPDATE_ONLINE_STATE
            self.request(method: .post, url: urlString, parameters: ["online": "1"], code: .UpdateOnlineState)
        })
    }()
    
    lazy var debouncedOfflineState : Debouncer = {
        return Debouncer(delay: 0.2, callback: {
            let urlString = self.API_URL_HOST + self.API_UPDATE_ONLINE_STATE
            self.request(method: .post, url: urlString, parameters: ["online": "0"], code: .UpdateOnlineState)
        })
    }()
    
    let errorTag = "MnurzSDK: "
    var sessionManager = SessionManager()
    
    init(state: MynurzSDKStateDevelopment) {
        super.init()
        if state == .Live {
            self.API_URL_HOST = "https://mynurz.com"
        }
        
        if state == .Staging {
            self.API_URL_HOST = "https://staging.mynurz.com"
        }
        
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        var requestHandler = MynurzSDKRequestHandler(accessToken: "", refreshTokenUrl: self.API_URL_HOST+API_REFRESH_TOKEN)
        if let token = TokenController.shared.get() {
            requestHandler = MynurzSDKRequestHandler(accessToken: token.token, refreshTokenUrl: self.API_URL_HOST+API_REFRESH_TOKEN)
        }
        self.sessionManager.adapter = requestHandler
        self.sessionManager.retrier = requestHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setOfflineState), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setOnlineState), name:NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setOnlineState), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let host = self.API_URL_HOST.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
        
        guard let networkManager = NetworkReachabilityManager(host: host) else {
            print(self.errorTag+"Network manager not listening")
            return
        }
        networkManager.listener = { status in
            if let delegate = self.delegate {
                switch status {
                case .notReachable:
                    self.setOfflineState()
                    delegate.responseError(message: "Network Unreachable", code: .None, errorCode: .NoNetwork, data: nil)
                    break
                case .unknown:
                    self.setOfflineState()
                    delegate.responseError(message: "Network Unreachable", code: .None, errorCode: .NoNetwork, data: nil)
                    break
                default:
                    self.setOnlineState()
                    break
                }
                return
            }
        }
        networkManager.startListening()
        reachablilityManager = networkManager
        self.addObserver(self, forKeyPath: "autoUpdateMap", options: [.new,.old], context: nil)
        if let validTimer = self.timer {
            validTimer.invalidate()
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "autoUpdateMap")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let value = change?[NSKeyValueChangeKey.newKey] as? Bool else {return}
        
        if value {
            if let validTimer = self.timer {
                validTimer.invalidate()
            }
            
            self.timer = Timer.runThisEvery(seconds: 5.0, handler: {_ in
                guard let validLatitude = self.latitude else {return}
                guard let validLongitude = self.longitude else {return}
                print(validLatitude,validLongitude)
                let urlString = self.API_URL_HOST + self.API_UPDATE_LOCATION
                let param = ["latitude" : "\(validLatitude)", "longitude":"\(validLongitude)"]
                self.request(method: .post, url: urlString, parameters: param, code: .UpdateLocation)
            })
        }else{
            if let validTimer = self.timer {
                validTimer.invalidate()
            }
        }
    }
    
    public func wipeDatabase(){
        guard let validFile = Realm.Configuration.defaultConfiguration.fileURL else {return}
        do {
            try FileManager.default.removeItem(at: validFile)
        }catch{
            print("error")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let validLocation = locations.first else {return}
        self.latitude = validLocation.coordinate.latitude
        self.longitude = validLocation.coordinate.longitude
    }
    
    @objc private func setOfflineState(){
        self.debouncedOfflineState.call()
    }
    
    @objc private func setOnlineState(){
        self.debouncedOnlineState.call()
    }
    
    private func updateData(data: JSON, code: MynurzSDKRequestCode){
        switch code {
        case .Login:
            let token = data["token"].string ?? ""
            let handler = MynurzSDKRequestHandler(accessToken: token, refreshTokenUrl: self.API_URL_HOST+API_REFRESH_TOKEN)
            self.sessionManager.adapter = handler
            self.sessionManager.retrier = handler
            TokenController.shared.put(token: token)
            break
        case .GetProfile:
            print(data)
            break
        case .Logout:
            TokenController.shared.drop()
        default:
            print(self.errorTag+"Unhandled update data for code \(code)")
            return
        }
        
    }
    
    private func request(url: String, image: UIImage, code: MynurzSDKRequestCode, progressCode: MynurzSDKRequestCode){
        let start = DispatchTime.now()
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "file.jpg", mimeType: "image/jpg")
            }
            
        }, to: url, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    let message = "Progress uploading file: \(Progress.fractionCompleted.rounded(toPlaces: 2))"
                    let data = JSON(Double: Progress.fractionCompleted.rounded(toPlaces: 2))
                    guard let validDelegate = self.delegate else {
                        print(self.errorTag+"No delegate attached")
                        return
                    }
                    print("\(HTTPMethod.post) \(url.self) \(message) \(code) \(timeInterval)")
                    validDelegate.responseSuccess(message: message, code: progressCode, data: data)
                })
                
                
                upload.responseJSON(completionHandler: { response in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    
                    guard let validDelegate = self.delegate else {
                        print(self.errorTag+"No delegate attached")
                        return
                    }
                    
                    guard let validResponse = response.response else {
                        validDelegate.responseError(message: "Empty response", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    guard let validData = response.data else {
                        validDelegate.responseError(message: "Empty response body", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    print("\(HTTPMethod.post) \(url.self) \(validResponse.statusCode) \(code) \(timeInterval)")
                    
                    let json = JSON(data: validData)
                    
                    guard let status = json["status"].bool else {
                        validDelegate.responseError(message: "Invalid response body for status", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    guard let message = json["message"].string else {
                        validDelegate.responseError(message: "Invalid response body for message", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    if validResponse.statusCode >= 200 && validResponse.statusCode < 500 {
                        if(status){
                            self.updateData(data: json["data"], code: code)
                            validDelegate.responseSuccess(message: message, code: code, data: json["data"])
                            return
                        }
                        validDelegate.responseError(message: message, code: code, errorCode: .RejectedByServer, data: json["data"])
                        return
                    }
                    validDelegate.responseError(message: message, code: code, errorCode: .RequestError, data: json["data"])
                    return
                })
            case .failure(let encodingError):
                print("error: \(encodingError)")
            }
        })
    }
    
    private func request(method: HTTPMethod, url: String, parameters: [String:String]?, code: MynurzSDKRequestCode){
        let start = DispatchTime.now()
        self.sessionManager
            .request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON{ response in
                let stop = DispatchTime.now()
                let timeInterval = Double(stop.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                
                guard let validDelegate = self.delegate else {
                    print(self.errorTag+"No delegate attached")
                    return
                }
                
                guard let validResponse = response.response else {
                    validDelegate.responseError(message: "Empty response", code: code, errorCode: .InvalidResponseData, data: nil)
                    return
                }
                
                print("\(method.self) \(url.self) \(validResponse.statusCode) \(code) \(timeInterval)")
                
                guard let validData = response.data else {
                    validDelegate.responseError(message: "Empty response body", code: code, errorCode: .InvalidResponseData, data: nil)
                    return
                }
                
                let json = JSON(data: validData)
                
                guard let status = json["status"].bool else {
                    validDelegate.responseError(message: "Invalid response body for status", code: code, errorCode: .InvalidResponseData, data: json)
                    return
                }
                
                guard let message = json["message"].string else {
                    validDelegate.responseError(message: "Invalid response body for message", code: code, errorCode: .InvalidResponseData, data: json)
                    return
                }
                
                if validResponse.statusCode >= 200 && validResponse.statusCode < 500 {
                    if(status){
                        self.updateData(data: json["data"], code: code)
                        validDelegate.responseSuccess(message: message, code: code, data: json["data"])
                        return
                    }
                    validDelegate.responseError(message: message, code: code, errorCode: .RejectedByServer, data: json["data"])
                    return
                }
                validDelegate.responseError(message: message, code: code, errorCode: .RequestError, data: json["data"])
                return
        }
    }
    
    // MARK: - All Role API
    
    public func login(email: String, password: String){
        let urlString = self.API_URL_HOST + self.API_LOGIN
        let params = ["email" : email, "password" : password]
        self.request(method: .post, url: urlString, parameters: params, code: .Login)
    }
    
    public func logout(){
        let urlString = self.API_URL_HOST + self.API_LOGOUT
        self.request(method: .get, url: urlString, parameters: nil, code: .Logout)
    }
    
    public func forgetPassword(email: String){
        let urlString = self.API_URL_HOST + self.API_FORGET_PASSWORD
        let params = ["email" : email]
        self.request(method: .post, url: urlString, parameters: params, code: .ForgetPassword)
    }
    
    public func getProfile(){
        let urlString = self.API_URL_HOST + self.API_PROFILE
        self.request(method: .get, url: urlString, parameters: nil, code: .GetProfile)
    }
    
    public func updateName(firstname: String, lastname: String){
        let urlString = self.API_URL_HOST + self.API_UPDATE_USER_NAME
        let params = ["first_name" : firstname, "last_name": lastname]
        self.request(method: .post, url: urlString, parameters: params, code: .UpdateName)
    }
    
    public func updatePhone(phone: String){
        let urlString = self.API_URL_HOST + self.API_UPDATE_USER_PHONE
        let params = ["mobile_phone" : phone]
        self.request(method: .post, url: urlString, parameters: params, code: .UpdatePhone)
    }
    
    public func updatePassword(password: String, confirmPassword: String){
        let urlString = self.API_URL_HOST + self.API_UPDATE_USER_PASSWORD
        let params = ["password" : password, "password_confirmation": confirmPassword]
        self.request(method: .post, url: urlString, parameters: params, code: .UpdatePassword)
    }

    
    // MARK: - Customer Role API
    
    public func registerCustomer(firstName: String, lastName: String, email: String, password: String, passwordConfirmation: String, mobilePhone: String){
        let urlString = self.API_URL_HOST + self.API_CUSTOMER_REGISTER
        let params = ["first_name" : firstName, "last_name" : lastName,"email":email,"password":password,"password_confirmation": passwordConfirmation,"mobile_phone":mobilePhone]
        self.request(method: .post, url: urlString, parameters: params, code: .RegisterCustomer)
    }

    public func updateSubscriptionCustomer(status: Bool){
        let urlString = self.API_URL_HOST + self.API_CUSTOMER_UPDATE_SUBSCRIBE
        let param = ["subscribe": (status ? "1" : "0")]
        self.request(method: .post, url: urlString, parameters: param, code: .UpdateCustomerSubscription)
    }
    
    public func updatePhotoProfileCustomer(photo: UIImage){
        let urlString = self.API_URL_HOST + self.API_CUSTOMER_UPDATE_PHOTO_PROFILE
        self.request(url: urlString, image: photo, code: .UpdateCustomerPhotoProfile, progressCode:.UpdateCustomerPhotoProfileProgress)
    }
    
    public func updateAddressCustomer(address: String, zip: String, district: Int, city: Int, state: Int, country: Int){
        let urlString = self.API_URL_HOST + self.API_CUSTOMER_UPDATE_ADDRESS
        let param = ["address":address, "zip":zip, "district":district.toString, "city":city.toString, "state":state.toString, "country":country.toString]
        self.request(method: .post, url: urlString, parameters: param, code: .UpdateCustomerAddress)
    }
    
    // MARK: - Freelancer Role API
    
    public func registerFreelancer(firstName: String, lastName: String, email: String, password: String, passwordConfirmation: String, mobilePhone: String){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_REGISTER
        let params = ["first_name" : firstName, "last_name" : lastName,"email":email,"password":password,"password_confirmation": passwordConfirmation,"mobile_phone":mobilePhone]
        self.request(method: .post, url: urlString, parameters: params, code: .RegisterFreelancer)
    }
    
    public func updatePhotoProfileFreelancer(photo: UIImage){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_UPDATE_PHOTO_PROFILE
        self.request(url: urlString, image: photo, code: .UpdateFreelancerPhotoProfile, progressCode:.UpdateFreelancerPhotoProfileProgress)
    }
    
    public func updatePhotoIDCardFreelancer(photo: UIImage){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_UPDATE_PHOTO_ID_CARD
        self.request(url: urlString, image: photo, code: .UpdateFreelancerIDCard, progressCode: .UpdateFreelancerIDCardProgress)
    }
    
    public func updateProfileFreelancer(profession: Int, gender: String, religion: Int, countryCode: String){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_UPDATE_PROFILE
        let param = ["profession":profession.toString, "gender":gender, "religion": religion.toString, "country_code": countryCode]
        self.request(method: .post, url: urlString, parameters: param, code: .UpdateFreelancerProfile)
    }
    
    public func updateSubscriptionFreelancer(status: Bool){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_UPDATE_SUBSCRIBE
        let param = ["subscribe": (status ? "1" : "0")]
        self.request(method: .post, url: urlString, parameters: param, code: .UpdateFreelancerSubscription)
    }
    
    public func updatePackagePriceFreelancer(packagePrice: Int){
        let urlString = self.API_URL_HOST + self.API_FREELANCER_UPDATE_PACKAGE_PRICE
        let param = ["package_price": packagePrice.toString]
        self.request(method: .post, url: urlString, parameters: param, code: .UpdateFreelancerPackagePrice)
    }
}
