//
//  EventsViewController.swift
//  Fidebeque
//
//  Created by Paulo Gama on 12/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import UIKit
import Firebase

class EventsViewController: UIViewController {

    var eventsArray: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchEvents() {
        
    }
    
}
