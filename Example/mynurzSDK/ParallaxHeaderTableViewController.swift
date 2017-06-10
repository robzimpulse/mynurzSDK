//
//  ParallaxHeaderTableViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/10/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MXParallaxHeader

class ParallaxHeaderTableViewController: UITableViewController, MXParallaxHeaderDelegate {

    @IBOutlet var headerView: UIView!
    var navigationOverlay: UIView?
    let navigationColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 300
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.minimumHeight = 64
        tableView.parallaxHeader.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let validNavBar = self.navBar {
            validNavBar.backgroundColor = UIColor.clear
            validNavBar.setBackgroundImage(UIImage(), for: .default)
            validNavBar.shadowImage = UIImage()
            validNavBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.clear]
            validNavBar.tintColor = UIColor.white
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let validNavBar = self.navBar {
            validNavBar.backgroundColor = nil
            validNavBar.setBackgroundImage(nil, for: .default)
            validNavBar.shadowImage = nil
            validNavBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
            validNavBar.tintColor = UIColor.blue
        }
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        guard let validNavbar = self.navBar else {return}
        validNavbar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(1-parallaxHeader.progress)]
    }
}
