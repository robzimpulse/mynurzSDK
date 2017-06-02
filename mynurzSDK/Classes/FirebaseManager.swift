//
//  FirebaseManager.swift
//  Pods
//
//  Created by Robyarta on 6/2/17.
//
//

import UIKit

class FirebaseManager: NSObject {
    var delegate: MynurzSDKDelegate?
    public static let sharedInstance = FirebaseManager()
    
    override init() {
        super.init()
        // TODO : Initialization for fcm listener
    }
    
}
