//
//  ProfileController.swift
//  Pods
//
//  Created by Robyarta on 5/16/17.
//
//

//
//  Token.swift
//  Pods
//
//  Created by Robyarta on 5/6/17.
//
//

import Foundation
import RealmSwift

class State: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Skill: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Role: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Profession: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class JobStatus: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Country: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class City: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class PromotionCategory: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class SkillExperience: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Religion: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class District: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Employment: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Area: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Degree: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class Relationship: Object{
    dynamic var id = 0
    dynamic var name = ""
}

class SettingController {
    
    static let sharedInstance = SettingController()
    
    var realm: Realm?
    
    func put(stateWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = State()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }
    
    func put(skillWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Skill()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(roleWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Role()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(professionWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Profession()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }
    
    func put(jobStatusWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = JobStatus()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(countryWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Country()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(cityWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = City()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(promotionCategoryWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = PromotionCategory()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(skillExperienceWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = SkillExperience()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(religionWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Religion()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(districtWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = District()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(employmentWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Employment()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }
    
    func put(areaWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Area()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }

    func put(degreeWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Degree()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }
    
    func put(relationshipWithId id:Int, name:String){
        self.realm = try! Realm()
        try! self.realm!.write {
            let state = Relationship()
            state.id = id
            state.name = name
            self.realm!.add(state)
        }
    }
    
    func drop(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Skill.self))
            self.realm!.delete(self.realm!.objects(Role.self))
            self.realm!.delete(self.realm!.objects(Profession.self))
            self.realm!.delete(self.realm!.objects(JobStatus.self))
            self.realm!.delete(self.realm!.objects(Country.self))
            self.realm!.delete(self.realm!.objects(PromotionCategory.self))
            self.realm!.delete(self.realm!.objects(SkillExperience.self))
            self.realm!.delete(self.realm!.objects(Religion.self))
            self.realm!.delete(self.realm!.objects(Employment.self))
            self.realm!.delete(self.realm!.objects(Degree.self))
            self.realm!.delete(self.realm!.objects(Relationship.self))
        }
    }
    
    func dropState(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(State.self))
        }
    }
    
    func dropCity(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(City.self))
        }
    }
    
    func dropDistrict(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(District.self))
        }
    }
    
    func dropArea(){
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Area.self))
        }
    }
}
