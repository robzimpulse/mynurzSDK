//
//  SkillExperience.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class SkillExperience: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class SkillExperienceController {
    
    public static let sharedInstance = SkillExperienceController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = SkillExperience()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<SkillExperience> {
        self.realm = try! Realm()
        return self.realm!.objects(SkillExperience.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(SkillExperience.self))
        }
    }
    
}
