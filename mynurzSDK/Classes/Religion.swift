//
//  Religion.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Religion: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class ReligionController {
    
    public static let sharedInstance = ReligionController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Religion()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Religion> {
        self.realm = try! Realm()
        return self.realm!.objects(Religion.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Religion.self))
        }
    }
    
}
