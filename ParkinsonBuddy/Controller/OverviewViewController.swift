//
//  ExportViewController.swift
//  ParkinsonBuddy
//
//  Created by Chiara on 06/04/23.
//

import Foundation
import UIKit
import CareKit
import SwiftUI

class OverviewViewController: UIViewController{
    
    let storeManager: OCKSynchronizedStoreManager
    var fetcher: ManualFetch
    var hostingController: UIHostingController<ListView>?
    
    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
        self.fetcher = ManualFetch(storeManager: storeManager)
        // Recupera il valore salvato, se presente, altrimenti imposta il valore di default a 0.0
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        // Create an instance of the UIHostingController with your SwiftUI view
        let hostingController = UIHostingController(rootView: ListView(storeManager: self.storeManager))
                
        // Add the hosting controller's view as a child of your view controller's view
        view.addSubview(hostingController.view)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        self.navigationController?.navigationBar.isHidden = true

        // Store the hosting controller so you can access it later if needed
        self.hostingController = hostingController
        
        
    }
    
    
}
