//
//  Area.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Area: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class AreaController {
    
    public static let sharedInstance = AreaController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Area()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Area> {
        self.realm = try! Realm()
        return self.realm!.objects(Area.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Area.self))
        }
    }
    
}
