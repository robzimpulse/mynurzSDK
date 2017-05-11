//
//  MynurzSDKRequestAdapter.swift
//  Pods
//
//  Created by Robyarta on 5/5/17.
//
//

import Foundation
import Alamofire

class MynurzSDKRequestHandler: RequestAdapter, RequestRetrier {
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
        guard response.statusCode == 401 else { completion(false, 0.0); return }
        requestsToRetry.append(completion)
        if !isRefreshing {
            refreshTokens { [weak self] succeeded, accessToken in
                guard let strongSelf = self else { return }
                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                if let accessToken = accessToken {
                    strongSelf.accessToken = accessToken
                }
                strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                strongSelf.requestsToRetry.removeAll()
            }
        }
    }
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        sessionManager.request(refreshTokenUrl, method: .post, parameters: ["token":self.accessToken], encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                if let json = response.result.value as? [String: Any], let accessToken = json["token"] as? String {
                    completion(true, accessToken)
                } else {
                    completion(false, nil)
                }
                strongSelf.isRefreshing = false
        }
    }
}
