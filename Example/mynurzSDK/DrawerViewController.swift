//
//  DrawerViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import KWDrawerController
import Shimmer
import SwiftyJSON
import mynurzSDK

class DrawerViewController: UITableViewController, DrawerControllerDelegate, MynurzSDKDelegate {

    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .done, target: self, action: #selector(openRightDrawer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .done, target: self, action: #selector(openLeftDrawer))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.delegate = self
//        sdk.setDelegate(delegate: self)
//        sdk.login(email: "freelancer@kronusasia.com", password: "111111")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func openLeftDrawer(){
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.openSide(.left)
    }
    
    func openRightDrawer(){
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.openSide(.right)
    }
    
    func drawerDidBeganAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - began animation")
    }
    
    func drawerDidFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - finish animation")
    }
    
    func drawerDidCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - cancel animation")
    }
    
    func drawerDidAnimation(drawerController: DrawerController, side: DrawerSide, percentage: Float) {
        //        print("\(self.className) - progress animation : \(percentage)")
    }
    
    func drawerWillFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will finish")
    }
    
    func drawerWillCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will cancel")
    }

    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print(sdk.isTokenRefreshable, sdk.isTokenValid)
    }
    
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print(sdk.isTokenRefreshable, sdk.isTokenValid)
    }
    
}

class LeftDrawerViewController: UIViewController, DrawerControllerDelegate {
    
    @IBOutlet weak var shimmerLabel: UILabel!
    @IBOutlet weak var shimmerView: FBShimmeringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.delegate = self
        
        shimmerView.contentView = shimmerLabel
        shimmerView.isShimmering = true
    }
    
    @IBAction func back(_ sender: Any) {
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.closeSide()
    }
    
    func drawerDidBeganAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - began animation")
    }
    
    func drawerDidFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - finish animation")
    }
    
    func drawerDidCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - cancel animation")
    }
    
    func drawerDidAnimation(drawerController: DrawerController, side: DrawerSide, percentage: Float) {
        //        print("\(self.className) - progress animation : \(percentage)")
    }
    
    func drawerWillFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will finish")
    }
    
    func drawerWillCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will cancel")
    }

    
}

class RightDrawerViewController: UIViewController, DrawerControllerDelegate {
    
    @IBOutlet weak var shimmerLabel: UILabel!
    @IBOutlet weak var shimmerView: FBShimmeringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.delegate = self
        
        shimmerView.contentView = shimmerLabel
        shimmerView.isShimmering = true
    }
    
    @IBAction func back(_ sender: Any) {
        guard let validDrawerController = self.drawerController else {return}
        validDrawerController.closeSide()
    }
    
    
    func drawerDidBeganAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - began animation")
    }
    
    func drawerDidFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - finish animation")
    }
    
    func drawerDidCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - cancel animation")
    }
    
    func drawerDidAnimation(drawerController: DrawerController, side: DrawerSide, percentage: Float) {
        //        print("\(self.className) - progress animation : \(percentage)")
    }
    
    func drawerWillFinishAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will finish")
    }
    
    func drawerWillCancelAnimation(drawerController: DrawerController, side: DrawerSide) {
        //        print("\(self.className) - will cancel")
    }

    
}
