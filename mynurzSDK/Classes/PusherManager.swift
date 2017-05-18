//
//  PusherManager.swift
//  Pods
//
//  Created by Robyarta on 5/18/17.
//
//

import UIKit
import PusherSwift

class PusherManager: NSObject, PusherDelegate{

    public static let sharedInstance = PusherManager()
    var delegate: MynurzSDKDelegate?
    var pusher: Pusher?
    lazy var state: ConnectionState = {
        guard let validPusher = self.pusher else { return ConnectionState.disconnected }
        return validPusher.connection.connectionState
    }()
    
    override init() {
        super.init()
        let options = PusherClientOptions(host: .cluster("ap1"))
        self.pusher = Pusher(key: "9d5b61bde9e815815545",options: options)
        guard let validPusher = pusher else {return}
        validPusher.delegate = self
        validPusher.connect()
    }
    
    public func subscribe(toChannelName name: String, event: String, callback: @escaping (Any?) -> Void) -> String?{
        guard let validPusher = pusher else {return nil}
        let channel = validPusher.subscribe(name)
        return channel.bind(eventName: event, callback: callback)
    }
    
    public func unsubscribe(withCallbackId name: String){
        guard let validPusher = pusher else {return}
        validPusher.unbind(callbackId: name)
    }
    
    public func unsubscribeAll(){
        guard let validPusher = pusher else {return}
        validPusher.unbindAll()
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("changedConnectionState : \(old) - \(new)")
    }
    
    func debugLog(message: String) {
        print("debugLog : \(message)")
    }
    
    func subscribedToChannel(name: String) {
        print("subscribedToChannel : \(name)")
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("failedToSubscribeToChannel : \(name) - \(error.debugDescription) - \(data as Any)")
    }
}
