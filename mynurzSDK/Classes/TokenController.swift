//
//  Token.swift
//  Pods
//
//  Created by Robyarta on 5/6/17.
//
//

import Foundation
import RealmSwift

class Token: Object{
    dynamic var token = ""
    dynamic var tokenIssuedAt = 0
    dynamic var tokenExpiredAt = 0
    dynamic var tokenLimitToRefresh = 0
    dynamic var roleId = 0
}

class TokenController {
    
    static let sharedInstance = TokenController()
    
    var realm: Realm?
    
    func get() -> Token? {
        self.realm = try! Realm()
        return self.realm!.objects(Token.self).first
    }
    
    func put(token:String, tokenIssuedAt:Int, tokenExpiredAt:Int, tokenLimitToRefresh:Int, roleId:Int){
        self.realm = try! Realm()
        try! self.realm!.write {
            let currentToken = Token()
            currentToken.token = token
            currentToken.tokenIssuedAt = tokenIssuedAt
            currentToken.tokenExpiredAt = tokenExpiredAt
            currentToken.tokenLimitToRefresh = tokenLimitToRefresh
            currentToken.roleId = roleId
            if let oldToken = self.realm!.objects(Token.self).first {
                self.realm?.delete(oldToken)
            }
            self.realm!.add(currentToken)
        }
    }
    
    func drop(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm?.delete((self.realm?.objects(Token.self))!)
        }
    }
}
