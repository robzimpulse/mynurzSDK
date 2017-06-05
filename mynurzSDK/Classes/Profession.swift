//
//  Profession.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Profession: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class ProfessionController {
    
    public static let sharedInstance = ProfessionController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Profession()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Profession> {
        self.realm = try! Realm()
        return self.realm!.objects(Profession.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Profession.self))
        }
    }
    
}
