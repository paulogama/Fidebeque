//
//  EventDetailsViewController.swift
//  Fidebeque
//
//  Created by Paulo Gama on 14/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import UIKit
import Firebase

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var feedbackTableView: UITableView!
    @IBOutlet weak var feedbackTextField: UITextField!
    
    var event: Event!
    
    var feedbackArray = [Feedback]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        feedbackTableView.contentInset = .init(top: 64.0, left: 0, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = event?.title
        
        fetchFeedback()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            feedbackTextField.frame = CGRect(x: feedbackTextField.frame.origin.x,
                                             y: feedbackTextField.frame.origin.y - endFrame.height,
                                             width: feedbackTextField.frame.size.width,
                                             height: feedbackTextField.frame.size.height)

            feedbackTableView.frame.size = CGSize(width: feedbackTableView.frame.size.width,
                                                  height: feedbackTextField.frame.origin.y)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }
    
    func fetchFeedback() {
        ref.child("feedbacks").child(event.uid).observe(.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.feedbackArray.removeAll()
                
                for feedbackSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let feedback = Feedback(snapshot: feedbackSnapshot) {
                        self.feedbackArray.append(feedback)
                    }
                    
                }
                
            }
            
            self.spinner.stopAnimating()
            self.feedbackTableView.isHidden = false
            self.feedbackTableView.reloadData()
            
        })
        
    }
    
    func saveFeedback(_ feedback: Feedback) {
        ref.child("feedbacks").child(event.uid).childByAutoId().setValue(["content": feedback.content ?? "",
                                                                          "timestamp": Date().timeIntervalSince1970])
    }
    
}

extension EventDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FEEDBACK_CELL, for: indexPath)
        
        let feedback = feedbackArray[indexPath.row]
        
        cell.textLabel?.text = feedback.content
        
        return cell
    }
    
}

extension EventDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            let feedback = Feedback(content: textField.text!)
        
            self.saveFeedback(feedback)
            
            feedbackArray.append(feedback)
            feedbackTableView.reloadData()
            
            textField.text = ""
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
