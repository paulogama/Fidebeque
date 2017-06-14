//
//  EventDetailsViewController.swift
//  Fidebeque
//
//  Created by Paulo Gama on 14/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var feedbackTableView: UITableView!
    @IBOutlet weak var feedbackTextField: UITextField!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = event?.title
        self.navigationItem.backBarButtonItem?.title = "tete"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
    }
    
}
