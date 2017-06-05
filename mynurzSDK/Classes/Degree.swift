//
//  Degree.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Degree: Object{
    public dynamic var id = 0
    public dynamic var name = ""
}

public class DegreeController {
    
    public static let sharedInstance = DegreeController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Degree()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Degree> {
        self.realm = try! Realm()
        return self.realm!.objects(Degree.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Degree.self))
        }
    }
    
}
