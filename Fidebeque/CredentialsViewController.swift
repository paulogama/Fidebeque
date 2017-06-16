//
//  CredentialsViewController.swift
//  Fidebeque
//
//  Created by Paulo Gama on 09/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import UIKit
import Firebase

class CredentialsViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            self.login(email: email, password: password)
        }
    }

    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Beleza", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if user != nil && error == nil {
                UserDefaults.standard.setValue(true, forKey: "isLogged")
                self?.performSegue(withIdentifier: Constants.HOME_SEGUE, sender: self)
            } else {
                self?.showErrorAlert(title: "Alerta", message: "Usuário e/ou senha inválidos")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.HOME_SEGUE {
            if let _ = segue.destination as? UINavigationController, let eventsViewController = segue.destination.childViewControllers[0] as? EventsViewController {
                print(eventsViewController)
            }
        }
    }
    
}

extension CredentialsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            self.signInButtonAction(signInButton)
        default:
            print("Unexpected textfield")
        }
        
        return true
    }
    
}
