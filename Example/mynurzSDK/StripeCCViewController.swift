//
//  StripeCheckoutViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import mynurzSDK
import SwiftyJSON
import Stripe

class StripeCCViewController: UIViewController, MynurzSDKDelegate, STPAddCardViewControllerDelegate {

    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STPPaymentConfiguration.shared().publishableKey = sdk.stripePublishableKey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func Show(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sdk.setDelegate(delegate: self)
    }
    
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print("\(message) - \(code) - \(errorCode)")
    }
    
    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print("\(message) - \(code)")
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        completion(nil)
        addCardViewController.dismiss(animated: true, completion: nil)
        self.sdk.postChargeStripe(param: ["source": token, "amount": 35000000, "currency":"SGD"])
    }

}
