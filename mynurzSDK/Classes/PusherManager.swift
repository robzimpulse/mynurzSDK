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
import CoreLocation

class PusherManager: NSObject, PusherDelegate, AuthRequestBuilderProtocol{
    let endpointManager = EndpointManager.sharedInstance
    public static let sharedInstance = PusherManager()
    var delegate: MynurzSDKDelegate?
    var pusher: Pusher?
    var presenceListener: PusherPresenceChannel?
    var locationListener: PusherChannel?
    var locationBindId: String?
    var chatListener: PusherChannel?
    var chatBindId: String?
    var userId: Int?
    
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
    
    func isUserOnline(userId: String) -> Bool{
        guard let validPresenceChannel = self.presenceListener else {return false}
        guard validPresenceChannel.findMember(userId: userId) != nil else {return false}
        return true
    }
    
    public func stopListening(){
        guard let validPusher = self.pusher else {return}
        
        if let validListener = chatListener {
            if let validBindId = chatBindId {
                validListener.unbind(eventName: "message", callbackId: validBindId)
            }
            validPusher.unsubscribe(validListener.name)
        }
        
        if let validListener = locationListener {
            if let validBindId = locationBindId {
                validListener.unbind(eventName: "update_location", callbackId: validBindId)
            }
            validPusher.unsubscribe(validListener.name)
        }
    }
    
    public func startListening(){
        guard let validPusher = self.pusher else {return}
        
        self.stopListening()
        
        if let user = ProfileController.sharedInstance.getCustomer() {
            
            let listener = validPusher.subscribe("private-chat.user.\(user.id)")
            let bindId = listener.bind(eventName: "message", callback: {data in
                guard let validDelegate = self.delegate else {return}
                validDelegate.responseSuccess(message: "1 New Message", code: .ReceivedChat, data: JSON(data as Any))
            })
            self.userId = user.id
            self.chatListener = listener
            self.chatBindId = bindId
            self.presenceListener = validPusher.subscribeToPresenceChannel(channelName: "presence-user")
            
        }
        
        if let user = ProfileController.sharedInstance.getFreelancer() {
            
            let listener = validPusher.subscribe("private-chat.freelancer.\(user.id)")
            let bindId = listener.bind(eventName: "message", callback: {data in
                guard let validDelegate = self.delegate else {return}
                validDelegate.responseSuccess(message: "1 New Message", code: .ReceivedChat, data: JSON(data as Any))
            })
            self.userId = user.id
            self.chatListener = listener
            self.chatBindId = bindId
            self.presenceListener = validPusher.subscribeToPresenceChannel(channelName: "presence-user")

        }
        
        let listener = validPusher.subscribe("private-location")
        let bindId = listener.bind(eventName: "client-location", callback: {data in
            guard let validDelegate = self.delegate else {return}
            validDelegate.responseSuccess(message: "Update Location", code: .UpdateLocation, data: JSON(data as Any))
        })
        self.locationListener = listener
        self.locationBindId = bindId
        
    }
    
    func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        guard let validListener = self.locationListener else {return}
        guard let validUserId = self.userId else {return}
        validListener.trigger(eventName: "client-location", data: [
            "userId":validUserId,
            "latitude":latitude.toString,
            "longitude":longitude.toString
        ])
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
//        print("changedConnectionState : \(old) - \(new)")
    }
    
    func debugLog(message: String) {
//        print("debugLog : \(message)")
    }
    
    func subscribedToChannel(name: String) {
//        print("subscribedToChannel : \(name)")
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
//        print("failedToSubscribeToChannel : \(name) - \(error.debugDescription) - \(data as Any)")
    }
    
    
}
