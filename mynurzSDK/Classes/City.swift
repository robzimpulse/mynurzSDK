//
//  City.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import Foundation
import RealmSwift

public class City: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class CityController {
    
    public static let sharedInstance = CityController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = City()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<City> {
        self.realm = try! Realm()
        return self.realm!.objects(City.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(City.self))
        }
    }
    
}
