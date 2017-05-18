//
//  RequestManager.swift
//  Pods
//
//  Created by Robyarta on 5/15/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON
import EZSwiftExtensions
import RealmSwift

public class RequestManager: NSObject {

    public var delegate: MynurzSDKDelegate?
    public static let sharedInstance = RequestManager()
    var sessionManager = SessionManager()
    let dataManager = DataManager.sharedInstance
    
    public override init() {
        super.init()
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        self.updateToken()
    }
    
    func updateToken(){
        let token = TokenController.sharedInstance.get()
        let sessionHandler = SessionHandler(accessToken: token?.token ?? "", refreshTokenUrl: EndpointManager.sharedInstance.REFRESH_TOKEN)
        self.sessionManager.adapter = sessionHandler
        self.sessionManager.retrier = sessionHandler
    }
    
    func request(method: HTTPMethod, url: String, parameters: [String:Any]?, code: RequestCode){
        let start = DispatchTime.now()
        
        self.updateToken()
        
        guard let validDelegate = self.delegate else {
            print("no delegate attached")
            return
        }
        
        self.sessionManager
            .request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON{ response in
                let stop = DispatchTime.now()
                let timeInterval = Double(stop.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                
                guard let validResponse = response.response else {
                    validDelegate.responseError(message: "Empty response", code: code, errorCode: .InvalidResponseData, data: nil)
                    return
                }
                
                print("\(method.self) \(url.self) \(validResponse.statusCode) \(timeInterval)")
                
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
                
                if status {
                    self.dataManager.putData(code: code, data: json)
                    validDelegate.responseSuccess(message: message, code: code, data: json)
                    return
                }
                
                validDelegate.responseError(message: message, code: code, errorCode: .RejectedByServer, data: json)
                return
        }
    }

    func request(url: String, parameters: [String:Any], code: RequestCode, progressCode: RequestCode){
        let start = DispatchTime.now()
        
        self.updateToken()
        
        guard let validDelegate = self.delegate else {
            print("no delegate attached")
            return
        }
        
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            
            for parameter in parameters {
                if let param = parameter.value as? UIImage {
                    guard let imageData = UIImageJPEGRepresentation(param, 0.5) else {continue}
                    multipartFormData.append(imageData, withName: parameter.key, fileName: "file.jpg", mimeType: "image/jpg")
                }
                if let param = parameter.value as? String {
                    guard let data = param.data(using: String.Encoding.utf8, allowLossyConversion: false) else {continue}
                    multipartFormData.append(data, withName: parameter.key)
                }
                if let param = parameter.value as? Int {
                    guard let data = "\(param)".data(using: String.Encoding.utf8, allowLossyConversion: false) else {continue}
                    multipartFormData.append(data, withName: parameter.key)
                }
                if let param = parameter.value as? Double {
                    guard let data = "\(param)".data(using: String.Encoding.utf8, allowLossyConversion: false) else {continue}
                    multipartFormData.append(data, withName: parameter.key)
                }
            }
            
            
        }, to: url, method: .post, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { progress in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    let percentage = progress.fractionCompleted.rounded(toPlaces: 2)
                    let message = "Progress uploading file: \(percentage * 100) %"
                    print("\(HTTPMethod.post) \(url.self) \(message) \(timeInterval)")
                    validDelegate.responseSuccess(message: message, code: progressCode, data: JSON(double: percentage))
                    return
                })
                
                upload.responseJSON(completionHandler: { response in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    
                    guard let validResponse = response.response else {
                        validDelegate.responseError(message: "Empty response", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    guard let validData = response.data else {
                        validDelegate.responseError(message: "Empty response body", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    print("\(HTTPMethod.post) \(url.self) \(validResponse.statusCode) \(timeInterval)")
                    
                    let json = JSON(data: validData)
                    
                    guard let status = json["status"].bool else {
                        validDelegate.responseError(message: "Invalid response body for status", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    guard let message = json["message"].string else {
                        validDelegate.responseError(message: "Invalid response body for message", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    if status {
                        validDelegate.responseSuccess(message: message, code: code, data: json)
                        return
                    }
                    
                    validDelegate.responseError(message: message, code: code, errorCode: .RejectedByServer, data: json)
                    return
                })
                
                return
            case .failure(let encodingError):
                
                validDelegate.responseError(message: encodingError.localizedDescription, code: code, errorCode: .RequestError, data: nil)
                
                return
            }
            
        })
        
    }
    
    func request(url: String, image: UIImage, code: RequestCode, progressCode: RequestCode){
        let start = DispatchTime.now()
        
        self.updateToken()
        
        guard let validDelegate = self.delegate else {
            print("no delegate attached")
            return
        }
        
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0.7) {
                multipartFormData.append(imageData, withName: "photo", fileName: "file.jpg", mimeType: "image/jpg")
            }
        }, to: url, method: .post, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { progress in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    let percentage = progress.fractionCompleted.rounded(toPlaces: 2)
                    let message = "Progress uploading file: \(percentage * 100) %"
                    print("\(HTTPMethod.post) \(url.self) \(message) \(timeInterval)")
                    validDelegate.responseSuccess(message: message, code: progressCode, data: JSON(double: percentage))
                    return
                })
                
                upload.responseJSON(completionHandler: { response in
                    let stop = DispatchTime.now()
                    let nanoTime = stop.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanoTime) / 1_000_000_000
                    
                    guard let validResponse = response.response else {
                        validDelegate.responseError(message: "Empty response", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    guard let validData = response.data else {
                        validDelegate.responseError(message: "Empty response body", code: code, errorCode: .InvalidResponseData, data: nil)
                        return
                    }
                    
                    print("\(HTTPMethod.post) \(url.self) \(validResponse.statusCode) \(timeInterval)")
                    
                    let json = JSON(data: validData)
                    
                    guard let status = json["status"].bool else {
                        validDelegate.responseError(message: "Invalid response body for status", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    guard let message = json["message"].string else {
                        validDelegate.responseError(message: "Invalid response body for message", code: code, errorCode: .InvalidResponseData, data: json)
                        return
                    }
                    
                    if status {
                        validDelegate.responseSuccess(message: message, code: code, data: json)
                        return
                    }
                    
                    validDelegate.responseError(message: message, code: code, errorCode: .RejectedByServer, data: json)
                    return
                })
                
                return
            case .failure(let encodingError):
                
                validDelegate.responseError(message: encodingError.localizedDescription, code: code, errorCode: .RequestError, data: nil)
                
                return
            }
            
        })
    }
}
