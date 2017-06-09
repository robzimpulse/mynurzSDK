//
//  MidtransCheckoutViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import mynurzSDK
import SwiftyJSON
import MidtransKit

class MidtransCCViewController: UIViewController, MynurzSDKDelegate, MidtransUIPaymentViewControllerDelegate {

    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MidtransConfig.shared().setClientKey(sdk.midtransClientKey, environment: .sandbox, merchantServerURL: sdk.midtransMerchantUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Show(_ sender: Any) {
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
    
}
