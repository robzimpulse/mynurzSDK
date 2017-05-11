//
//  Token.swift
//  Pods
//
//  Created by Robyarta on 5/6/17.
//
//

import Foundation
import RealmSwift

public class Token: Object{
    dynamic public var token = ""
    dynamic public var tokenIssuedAt = 0
    dynamic public var tokenExpiredAt = 0
    dynamic public var tokenLimitToRefresh = 0
}

public class TokenController {
    
    public static let shared = TokenController()
    private var realm: Realm?
    
    public func get() -> Token? {
        self.realm = try! Realm()
        return self.realm!.objects(Token.self).first
    }
    
    func put(token: String, tokenIssuedAt: Int, tokenExpiredAt: Int, tokenLimitToRefresh: Int){
        self.realm = try! Realm()
        try! self.realm!.write {
            let currentToken = Token()
            currentToken.token = token
            currentToken.tokenIssuedAt = tokenIssuedAt
            currentToken.tokenExpiredAt = tokenExpiredAt
            currentToken.tokenLimitToRefresh = tokenLimitToRefresh
            if let oldToken = self.realm!.objects(Token.self).first {
                self.realm?.delete(oldToken)
            }
            self.realm!.add(currentToken)
        }
    }
    
    public func drop(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm?.delete((self.realm?.objects(Token.self))!)
        }
    }
}
