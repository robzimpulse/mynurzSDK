//
//  VCPlaceHolderViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import StatefulViewController

class VCPlaceHolderViewController: UIViewController, StatefulViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(fetchData))
        tableView.tableFooterView = UIView()
        loadingView = LoadingView(frame: tableView.frame)
        emptyView = EmptyView(frame: tableView.frame)
        errorView = ErrorView(frame: tableView.frame)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupInitialViewState()
        fetchData()
    }
    
    func fetchData(){
        if currentState == .Loading {return}
        self.dataArray = [String]()
        startLoading(animated: true, completion: {
            print("start loading")
        })
        
        Timer.runThisAfterDelay(seconds: 2.0, after: {
            
            let stage = Int.random(within: 0..<3)
            
            switch stage {
            case 0:
                // Success
                self.dataArray = ["Merlot", "Sauvignon Blanc", "Blaufränkisch", "Pinot Nior"]
                self.tableView.reloadData()
                self.endLoading(error: nil, completion: {
                    print("end loading")
                })
                break
            case 1:
                // Error
                self.endLoading(error: NSError(domain: "foo", code: -1, userInfo: nil))
                break
            default:
                // No Content
                self.endLoading(error: nil)
                break
            }
            
        })
        
    }
    
    func hasContent() -> Bool {
        return dataArray.count > 0
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

extension VCPlaceHolderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
}

class BasicPlaceholderView: UIView {
    
    let centerView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.white
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(centerView)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(>=20)-[centerView]-(>=20)-|", options: .alignAllCenterX, metrics: nil, views: ["centerView": centerView])
        let hConstraint = NSLayoutConstraint(item: centerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let centerConstraint = NSLayoutConstraint(item: centerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        centerConstraint.priority = 750
        
        addConstraints(vConstraints)
        addConstraint(hConstraint)
        addConstraint(centerConstraint)
    }
    
}

class LoadingView: BasicPlaceholderView, StatefulPlaceholderView {
    
    let label = UILabel()
    
    override func setupView() {
        super.setupView()
        
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(label)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(activityIndicator)
        
        let views = ["label": label, "activity": activityIndicator]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[activity]-[label]-|", options: [], metrics: nil, views: views)
        let vConstraintsLabel = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
        let vConstraintsActivity = NSLayoutConstraint.constraints(withVisualFormat: "V:|[activity]|", options: [], metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(vConstraintsLabel)
        centerView.addConstraints(vConstraintsActivity)
    }
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

class EmptyView: BasicPlaceholderView {
    
    let label = UILabel()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.white
        
        label.text = "No Content."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(label)
        
        let views = ["label": label]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(vConstraints)
    }
    
}

class ErrorView: BasicPlaceholderView {
    
    let textLabel = UILabel()
    let detailTextLabel = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.white
        
        self.addGestureRecognizer(tapGestureRecognizer)
        
        textLabel.text = "Something went wrong."
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(textLabel)
        
        detailTextLabel.text = "Tap to reload"
        detailTextLabel.numberOfLines = 0
        detailTextLabel.textAlignment = .center
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.footnote)
        detailTextLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
        detailTextLabel.textAlignment = .center
        detailTextLabel.textColor = UIColor.gray
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(detailTextLabel)
        
        let views = ["label": textLabel, "detailLabel": detailTextLabel]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
        let hConstraintsDetail = NSLayoutConstraint.constraints(withVisualFormat: "|-[detailLabel]-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-[detailLabel]-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(hConstraintsDetail)
        centerView.addConstraints(vConstraints)
    }
    
}
