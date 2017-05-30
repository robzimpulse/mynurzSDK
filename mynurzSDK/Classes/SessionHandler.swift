//
//  TokenHandler.swift
//  Pods
//
//  Created by Robyarta on 5/15/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON
import EZSwiftExtensions

class SessionHandler: RequestAdapter, RequestRetrier {
    private var accessToken: String
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    private let lock = NSLock()
    private var requestsToRetry: [RequestRetryCompletion] = []
    private var isRefreshing = false
    private var refreshTokenUrl: String
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    init(accessToken: String, refreshTokenUrl: String) {
        self.accessToken = accessToken
        self.refreshTokenUrl = refreshTokenUrl
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("mynurz", forHTTPHeaderField: "X-Mynurz-Token")
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        guard let response = request.task?.response as? HTTPURLResponse else {return}
        guard response.statusCode == 401 else { completion(false, 0.0); return}
        requestsToRetry.append(completion)
        refreshTokens { succeeded, accessToken in
            self.lock.lock() ; defer { self.lock.unlock() }
            if let accessToken = accessToken {
                self.accessToken = accessToken
            }
            self.requestsToRetry.forEach {$0(succeeded, 1.0)}
            self.requestsToRetry.removeAll()
        }
    }
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        sessionManager.adapter = self
        let start = DispatchTime.now()
        sessionManager.request(refreshTokenUrl, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                self.isRefreshing = false
                
                let stop = DispatchTime.now()
                let timeInterval = Double(stop.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                
                guard let validResponse = response.response else {
                    completion(false,nil)
                    return
                }
                
                print("\(HTTPMethod.get) \(self.refreshTokenUrl) \(validResponse.statusCode) \(timeInterval)")
                
                guard let validData = response.data else {
                    print("empty response body")
                    completion(false,nil)
                    return
                }
                
                let json = JSON(data: validData)
                
                guard json["status"].bool != nil else {
                    print("invalid response body for status")
                    completion(false,nil)
                    return
                }
                
                guard json["message"].string != nil else {
                    print("invalid response body for message")
                    completion(false,nil)
                    return
                }
                
                guard let token = json["data"]["token"].string else {
                    print("no token found on data response")
                    completion(false,nil)
                    return
                }
                
                guard let tokenIssuedAt = json["data"]["token_issued_at"].string else {
                    print("no token_issued_at found on data response")
                    completion(false,nil)
                    return
                }
                
                guard let tokenExpiredAt = json["data"]["token_expired_at"].string else {
                    print("no token_expired_at found on data response")
                    completion(false,nil)
                    return
                }
                
                guard let tokenLimitToRefresh = json["data"]["token_limit_to_refresh"].string else {
                    print("no token_limit_to_refresh found on data response")
                    completion(false,nil)
                    return
                }
                
                guard let roleId = json["data"]["role_id"].int else {
                    print("no role_id found on data response")
                    completion(false,nil)
                    return
                }
                
                print("Token refreshed")
                print(json)
                TokenController.sharedInstance.put(token: token, tokenIssuedAt: tokenIssuedAt, tokenExpiredAt: tokenExpiredAt, tokenLimitToRefresh: tokenLimitToRefresh, roleId: roleId)
                completion(true,token)
        }
    }
}
