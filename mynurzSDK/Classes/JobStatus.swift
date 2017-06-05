//
//  JobStatus.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class JobStatus: Object{
    dynamic var id = 0
    dynamic var name = ""
}

public class JobStatusController {
    
    public static let sharedInstance = JobStatusController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = JobStatus()
            object.id = id
            object.name = name
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<JobStatus> {
        self.realm = try! Realm()
        return self.realm!.objects(JobStatus.self)
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(JobStatus.self))
        }
    }
    
}
