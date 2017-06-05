//
//  Skill.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Skill: Object{
    public dynamic var id = 0
    public dynamic var name = ""
}

public class SkillController {
    
    public static let sharedInstance = SkillController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Skill()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Skill> {
        self.realm = try! Realm()
        return self.realm!.objects(Skill.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Skill.self))
        }
    }
    
}
