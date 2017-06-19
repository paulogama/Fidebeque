//
//  AddEventViewController.swift
//  Fidebeque
//
//  Created by Paulo Gama on 19/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    @IBOutlet weak var initialTime: UIDatePicker!
    @IBOutlet weak var finalTime: UIDatePicker!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTouchSave(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" {
            let title = titleTextField.text
            let date = self.eventDate.date
            let initialTime = self.initialTime.date
            let finalTime = self.finalTime.date
            
            let event = Event(uid: "", title: title!, date: date, startHour: initialTime, endHour: finalTime)
            
            event.save(reference: ref)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NEW_EVENT_NOTIFICATION), object: nil)
    
            self.dismissKeyboard()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func didTouchView(_ sender: UITapGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
}

extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        
        return true
    }
    
}
