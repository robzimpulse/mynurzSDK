//
//  GoogleMapViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/10/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GoogleMaps
import mynurzSDK

class GoogleMapViewController: UIViewController {

    let sdk = MynurzSDK.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(sdk.googleMapKey)
        let camera = GMSCameraPosition.camera(withLatitude: -6.1930799,longitude: 106.7742516,zoom: 14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        view = mapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
