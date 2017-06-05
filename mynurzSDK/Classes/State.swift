//
//  State.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class State: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class StateController {
    
    public static let sharedInstance = StateController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = State()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<State> {
        self.realm = try! Realm()
        return self.realm!.objects(State.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(State.self))
        }
    }
    
}
