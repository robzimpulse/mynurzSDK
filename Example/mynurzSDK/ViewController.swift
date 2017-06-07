//
//  ViewController.swift
//  mynurzSDK
//
//  Created by kugelfang.killaruna@gmail.com on 05/11/2017.
//  Copyright (c) 2017 kugelfang.killaruna@gmail.com. All rights reserved.
//

import UIKit
import MidtransKit
import Stripe
import mynurzSDK
import SwiftyJSON

class ViewController: UIViewController, MidtransUIPaymentViewControllerDelegate, STPAddCardViewControllerDelegate, MynurzSDKDelegate {
    
    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MidtransConfig.shared().setClientKey(sdk.midtransClientKey, environment: .sandbox, merchantServerURL: sdk.midtransMerchantUrl)
        STPPaymentConfiguration.shared().publishableKey = sdk.stripePublishableKey
        sdk.setDelegate(delegate: self)
    }

    // example checkout using midtrans (indonesia)
    @IBAction func checkoutMidtrans(_ sender: Any) {
        guard let addressDetail = MidtransAddress(firstName: "firstnameAddress", lastName: "lastnameAddress", phone: "081222542156", address: "jln dharmahusada 38b", city: "Surabaya", postalCode: "60285", countryCode: "IDN") else {return}
        guard let itemDetails = MidtransItemDetail(itemID: "item 1", name: "testing item", price: 350000, quantity: 1) else {return}
        guard let customerDetails = MidtransCustomerDetails(firstName: "firstname", lastName: "lastname", email: "kugelfang.killaruna@gmail.com", phone: "081222542156", shippingAddress: addressDetail, billingAddress: addressDetail) else {return}
        guard let transactionDetail = MidtransTransactionDetails(orderID: "0002", andGrossAmount: 350000) else {return}
        
        MidtransMerchantClient.shared().requestTransactionToken(with: transactionDetail, itemDetails: [itemDetails], customerDetails: customerDetails, completion: { token, error in
            if let validResponseToken = token {
                if let midTransView = MidtransUIPaymentViewController(token: validResponseToken) {
                    midTransView.paymentDelegate = self
                    self.present(midTransView, animated: true, completion: nil)
                }
            }
        })
    }
    
    // example checkout using omise (thailand)
    @IBAction func checkoutOmise(_ sender: Any) {
        
    }
    
    // example checkout using stripe (singapore)
    @IBAction func checkoutStripe(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Midtrans delegate
    
    func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
        print(viewController)
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
        print(error)
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
        print(result)
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
        print(result)
    }
    
    // MARK: Stripe delegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        completion(nil)
        addCardViewController.dismiss(animated: true, completion: nil)
        self.sdk.postChargeStripe(param: ["source": token, "amount": 35000000, "currency":"SGD"])
    }
    
    // MARK: MynurzSDK delegate
    
    func responseError(message: String, code: RequestCode, errorCode: ErrorCode, data: JSON?) {
        print("\(message) - \(code) - \(errorCode)")
    }
    
    func responseSuccess(message: String, code: RequestCode, data: JSON) {
        print("\(message) - \(code)")
    }
    
}

