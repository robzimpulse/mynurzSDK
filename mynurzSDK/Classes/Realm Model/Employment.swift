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
    
    public func get(byId id: Int) -> Employment? {
        self.realm = try! Realm()
        return self.realm!.objects(Employment.self).filter("id = '\(id)'").first
    }
    
    public func get(byName name: String) -> Employment? {
        self.realm = try! Realm()
        return self.realm!.objects(Employment.self).filter("name = '\(name)'").first
    }
    
    public func drop() {
        self.realm = try! Realm()
        try! self.realm!.write {
            self.realm!.delete(self.realm!.objects(Employment.self))
        }
    }
    
}

public class EmploymentTablePicker: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController?
    open var customFont: UIFont?
    open var didSelectClosure: ((Int, String) -> ())?
    var filteredData = [Employment]()
    var data = [Employment]()
    let controller = EmploymentController.sharedInstance
    
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
        
        for appenData in controller.get() {
            data.append(appenData)
        }
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filter(_ searchText: String){
        filteredData = [Employment]()
        
        self.data.forEach({ employment in
            if employment.name.characters.count > searchText.characters.count {
                let result = employment.name.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.characters.startIndex ..< searchText.characters.endIndex)
                if result == .orderedSame {
                    filteredData.append(employment)
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
        validClosure(selectedData.id, selectedData.name)
    }
    
}
