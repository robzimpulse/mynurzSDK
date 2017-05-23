//
//  PusherManager.swift
//  Pods
//
//  Created by Robyarta on 5/18/17.
//
//

import UIKit
import PusherSwift
import SwiftyJSON

class PusherManager: NSObject, PusherDelegate, AuthRequestBuilderProtocol{
    let endpointManager = EndpointManager.sharedInstance
    public static let sharedInstance = PusherManager()
    var delegate: MynurzSDKDelegate?
    var pusher: Pusher?
    var customerListener: String?
    var freelancerListener: String?
    var presenceListener: PusherPresenceChannel?
    lazy var state: ConnectionState = {
        guard let validPusher = self.pusher else { return ConnectionState.disconnected }
        return validPusher.connection.connectionState
    }()
    
    override init() {
        super.init()
        let options = PusherClientOptions(authMethod: .authRequestBuilder(authRequestBuilder: self),host: .cluster("ap1"))
        self.pusher = Pusher(key: "9d5b61bde9e815815545",options: options)
        guard let validPusher = pusher else {
            print("no delegate attached")
            return
        }
        validPusher.delegate = self
        validPusher.connect()
    }
    
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        guard let token = TokenController.sharedInstance.get() else {return nil}
        guard let firstString = channelName.split("-").first else {return nil}
        switch firstString {
        case "private":
            var urlRequest = URLRequest(url: URL(string: endpointManager.PUSHER_PRIVATE)!)
            urlRequest.setValue("Bearer " + token.token, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("mynurz", forHTTPHeaderField: "X-Mynurz-Token")
            urlRequest.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
            urlRequest.httpMethod = "POST"
            return urlRequest
            case "presence":
            var urlRequest = URLRequest(url: URL(string: endpointManager.PUSHER_PRESENCE)!)
            urlRequest.setValue("Bearer " + token.token, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("mynurz", forHTTPHeaderField: "X-Mynurz-Token")
            urlRequest.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
            urlRequest.httpMethod = "POST"
            return urlRequest
        default:
            let urlRequest = URLRequest(url: URL(string: "")!)
            return urlRequest
        }
    }
    
    public func isUserOnline(userId: String) -> Bool{
        guard let validPresenceChannel = self.presenceListener else {return false}
        guard validPresenceChannel.findMember(userId: userId) != nil else {return false}
        return true
    }
    
    public func stopListening(){
        if let customer = ProfileController.sharedInstance.getCustomer() {
            
            if let validListener = self.customerListener {
                self.unsubscribe(withChannelName: "private-chat.user.\(customer.id)", callbackId: validListener)
            }
            
        }
        
        if let freelancer = ProfileController.sharedInstance.getFreelancer() {
            
            if let validListener = self.freelancerListener {
                self.unsubscribe(withChannelName: "private-chat.freelancer.\(freelancer.id)", callbackId: validListener)
            }
        }
        
    }
    
    public func startListening(){
        guard let validPusher = self.pusher else {return}
        
        self.stopListening()
        
        if let user = ProfileController.sharedInstance.getCustomer() {
            
            self.customerListener = self.subscribe(toChannelName: "private-chat.user.\(user.id)", event: "message", callback: { data in
                guard let validDelegate = self.delegate else {return}
                validDelegate.responseSuccess(message: "1 New Message", code: .ReceivedChat, data: JSON(data as Any))
            })
            
            self.presenceListener = validPusher.subscribeToPresenceChannel(channelName: "presence-user")
        }
        
        if let user = ProfileController.sharedInstance.getFreelancer() {
            
            self.customerListener = self.subscribe(toChannelName: "private-chat.user.\(user.id)", event: "message", callback: { data in
                guard let validDelegate = self.delegate else {return}
                validDelegate.responseSuccess(message: "1 New Message", code: .ReceivedChat, data: JSON(data as Any))
            })
            
            self.presenceListener = validPusher.subscribeToPresenceChannel(channelName: "presence-user")
        }
        
    }
    
    public func subscribe(toChannelName name: String, event: String, callback: @escaping (Any?) -> Void) -> String?{
        guard let validPusher = pusher else {return nil}
        let channel = validPusher.subscribe(name)
        return channel.bind(eventName: event, callback: callback)
    }
    
    public func unsubscribe(withChannelName name: String, callbackId: String){
        guard let validPusher = pusher else {return}
        validPusher.unbind(callbackId: name)
        validPusher.unsubscribe(name)
    }
    
    public func unbindAll(){
        guard let validPusher = pusher else {return}
        validPusher.unbindAll()
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
//        print("changedConnectionState : \(old) - \(new)")
    }
    
    func debugLog(message: String) {
//        print("debugLog : \(message)")
    }
    
    func subscribedToChannel(name: String) {
        print("subscribedToChannel : \(name)")
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
//        print("failedToSubscribeToChannel : \(name) - \(error.debugDescription) - \(data as Any)")
    }
    
    
}
