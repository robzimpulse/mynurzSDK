//
//  PromotionCategory.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class PromotionCategory: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class PromotionCategoryController {
    
    public static let sharedInstance = PromotionCategoryController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = PromotionCategory()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<PromotionCategory> {
        self.realm = try! Realm()
        return self.realm!.objects(PromotionCategory.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(PromotionCategory.self))
        }
    }
    
}
