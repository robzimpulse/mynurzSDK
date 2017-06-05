//
//  Employee.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Employment: Object{
    public dynamic var id = 0
    public dynamic var name = ""
}

public class EmploymentController {
    
    public static let sharedInstance = EmploymentController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Employment()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Employment> {
        self.realm = try! Realm()
        return self.realm!.objects(Employment.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Employment.self))
        }
    }
    
}
