//
//  Relationship.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Relationship: Object{
    public dynamic var id = 0
    public dynamic var name = ""
}

public class RelationshipController {
    
    public static let sharedInstance = RelationshipController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Relationship()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Relationship> {
        self.realm = try! Realm()
        return self.realm!.objects(Relationship.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Relationship.self))
        }
    }
    
}
