//
//  Country.swift
//  Pods
//
//  Created by Robyarta on 6/5/17.
//
//

import UIKit
import RealmSwift

public class Country: Object{
    public dynamic var id = 0
    public dynamic var name = ""
    public dynamic var countryCode = ""
    public dynamic var countryCodeIso3 = ""
    public dynamic var enable = 0
}

public class CountryController {
    
    public static let sharedInstance = CountryController()
    
    var realm: Realm?
    
    public func put(id:Int, name:String, countryCode:String, countryCodeIso3:String, enable:Int) {
        self.realm = try! Realm()
        try! self.realm!.write {
            let object = Country()
            object.id = id
            object.name = name
            object.countryCode = countryCode
            object.countryCodeIso3 = countryCodeIso3
            object.enable = enable
            self.realm!.add(object)
        }
    }
    
    public func get() -> Results<Country> {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self)
    }
    
    public func get(byId id: Int) -> Country? {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self).filter("id = '\(id)'").first
    }
    
    public func get(byName name: String) -> Country? {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self).filter("name = '\(name)'").first
    }
    
    public func get(byCountryCode countryCode: String) -> Country? {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self).filter("countryCode = '\(countryCode)'").first
    }
    
    public func get(byCountryCodeIso3 countryCodeIso3: String) -> Country? {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self).filter("countryCodeIso3 = '\(countryCodeIso3)'").first
    }
    
    public func get(byEnabled enable: Int) -> Results<Country> {
        self.realm = try! Realm()
        return self.realm!.objects(Country.self).filter("enable = \(enable)")
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Country.self))
        }
    }
    
}

public class CountryTablePicker: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController?
    open var customFont: UIFont?
    open var didSelectClosure: ((Int, String, String, String) -> ())?
    var filteredData = [Country]()
    var data = [Country]()
    let controller = CountryController.sharedInstance
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if self.tableView.tableHeaderView == nil {
            let mySearchController = UISearchController(searchResultsController: nil)
            mySearchController.searchResultsUpdater = self
            mySearchController.dimsBackgroundDuringPresentation = false
            self.tableView.tableHeaderView = mySearchController.searchBar
            searchController = mySearchController
        }
        self.tableView.reloadData()
        self.definesPresentationContext = true
        
        for appenData in controller.get(byEnabled: 1) {
            data.append(appenData)
        }
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filter(_ searchText: String){
        filteredData = [Country]()
        
        self.data.forEach({ country in
            if country.name.characters.count > searchText.characters.count {
                let result = country.name.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.characters.startIndex ..< searchText.characters.endIndex)
                if result == .orderedSame {
                    filteredData.append(country)
                }
            }
        })
        
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let validText = searchController.searchBar.text else {return}
        filter(validText)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let validSearchController = searchController else {return self.data.count}
        guard let validText = validSearchController.searchBar.text else {return self.data.count}
        
        if validText.characters.count > 0 {
            return self.filteredData.count
        }
        
        return self.data.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        
        if let validLabel = cell.textLabel {
            if let validSearchController = searchController {
                if validSearchController.searchBar.text!.characters.count > 0 {
                    validLabel.text = filteredData[indexPath.row].name
                }else{
                    validLabel.text = data[indexPath.row].name
                }
            }
            
            if let validFont = customFont {
                validLabel.font = validFont
            }
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let validClosure = self.didSelectClosure else {return}
        let selectedData = self.data[indexPath.row]
        validClosure(selectedData.id,selectedData.name, selectedData.countryCode, selectedData.countryCodeIso3)
    }
    
}
