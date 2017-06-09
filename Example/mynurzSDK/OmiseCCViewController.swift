//
//  OmiseCheckoutViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import mynurzSDK
import SwiftyJSON
import OmiseSDK

class OmiseCCViewController: UIViewController, MynurzSDKDelegate, CreditCardFormDelegate {

    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Show(_ sender: Any) {
        let creditCardView = CreditCardFormController.makeCreditCardForm(withPublicKey: sdk.omisePublicKey)
        creditCardView.delegate = self
        creditCardView.handleErrors = true
        let navigationController = UINavigationController(rootViewController: creditCardView)
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
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)
        print(error)
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        controller.dismiss(animated: true, completion: nil)
        guard let validToken = token.tokenId else {return}
        self.sdk.postChargeOmise(param: ["card": validToken, "amount": 35000000, "currency":"THB"])
        
    }
}
