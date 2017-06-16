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

    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var eventsArray = [Event]()
     var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        eventsTableView.contentInset = .init(top: 64.0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchEvents() {
        ref.child("channels").observe(.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.eventsArray.removeAll()
                
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let event = Event(snapshot: events) {
                        self.eventsArray.append(event)
                    }
                    
                }
                
            }
            
            self.spinner.stopAnimating()
            self.eventsTableView.isHidden = false
            self.eventsTableView.reloadData()
            
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        
        if segue.identifier == Constants.EVENT_DETAILS_SEGUE {
            if let eventDetailsViewController = segue.destination as? EventDetailsViewController {
                eventDetailsViewController.event = eventsArray[indexPath.row]
            }
        }
    }
}

extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.EVENT_CELL, for: indexPath)
        
        let event = eventsArray[indexPath.row]
        
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = event.date?.toString()
        
        return cell
    }

}

extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.EVENT_DETAILS_SEGUE, sender: indexPath)
    }
    
}
