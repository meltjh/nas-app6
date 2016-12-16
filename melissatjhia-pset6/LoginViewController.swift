//
//  LoginViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 07-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var user: User?
    var restoredEmail: String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastUsedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            // Go to next view when the login has succeeded.
            self.performSegueIfUser(user: user)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lastLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Log in
    
    
    @IBAction func emailReturnDidTouch(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    /// Calls login function when button is pressed.
    @IBAction func loginAction(_ sender: Any) {
        login(sender as AnyObject)
    }
    
    func lastLogin() {
        if let last = UserDefaults.standard.object(forKey: "ZalandoLastUsed") as? Date {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: last)
            
            let year =  String(describing: components.year!)
            let month = String(describing: components.month!)
            let day = String(describing: components.day!)
            print("LAST", last)
            lastUsedLabel.isHidden = false
            lastUsedLabel.text = "Last visit: \(day)/\(month)/\(year) "
        }
    }
    
    // TODO: Enter login + focus vanaf gebruikersnaam naar password
    
    /// Signing in.
    func login(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { user, error in
                                if error != nil {
                                    if let err = FIRAuthErrorCode(rawValue: error!._code) {
                                        let errorTitle = "Failed to sign in"
                                        var errorMessage = ""
                                        
                                        switch err {
                                        case .errorCodeInvalidEmail:
                                            errorMessage = "This is not a valid email address."
                                        case .errorCodeUserDisabled:
                                            errorMessage = "This account has been disabled."
                                        case .errorCodeWrongPassword:
                                            errorMessage = "This email address and password combination is wrong."
                                        default:
                                            errorMessage = "Unable to sign in. Please check your email address and password."
                                        }
                                        self.showErrorAlert(errorTitle: errorTitle, errorMessage: errorMessage)
                                    }
                                }
                                else {
                                    self.performSegueIfUser(user: user)
                                }
        }
    }
    
    func performSegueIfUser(user: FIRUser?) {
        if user != nil {
            self.user = User(authData: user!)
            self.performSegue(withIdentifier: "login", sender: nil)
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    // MARK: - Register
    
    /// Alert controller is shown in which the user can register.
    @IBAction func registerDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        
                                                                        FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!,
                                                                                               password: self.passwordTextField.text!)
                                                                    }
                                                                    else {
                                                                        if let err = FIRAuthErrorCode(rawValue: error!._code) {
                                                                            
                                                                            let errorTitle = "Failed to register"
                                                                            var errorMessage = ""
                                                                            
                                                                            switch err {
                                                                            case .errorCodeInvalidEmail:
                                                                                errorMessage = "This is not a valid email address."
                                                                                
                                                                            case .errorCodeEmailAlreadyInUse:
                                                                                errorMessage = "There already exists an account with this email address."
                                                                                
                                                                            case .errorCodeWeakPassword:
                                                                                errorMessage = "The chosen password is too weak."
                                                                            default:
                                                                                errorMessage = "Something went wrong."
                                                                            }
                                                                            self.showErrorAlert(errorTitle: errorTitle, errorMessage: errorMessage)
                                                                        }
                                                                    }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default))
        present(alertController, animated: true)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(emailTextField.text, forKey: "restoredEmail")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        restoredEmail = coder.decodeObject(forKey: "restoredEmail") as! String?
        emailTextField.text = restoredEmail
        super.decodeRestorableState(with: coder)
    }
}
