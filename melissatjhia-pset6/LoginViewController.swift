//
//  LoginViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 07-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//
//  This class belongs to the first View that is shown when the app is launched.
//  The user can log in or register.

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var restoredEmail: String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastUsedLabel: UILabel!
    
    // MARK: - Loading/appearing of the View
    
    /// When the view has loaded, a listener is created that keeps track on
    /// whether the used logged in.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            self.performSegueIfUser(user: user)
        }
    }
    
    /// When the view appears, the last time the app was opened is shown.
    override func viewDidAppear(_ animated: Bool) {
        showLastUse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Presents a label with the date of the last time the app was used.
    func showLastUse() {
        if let last = UserDefaults.standard.object(forKey: "ZalandoLastUsed")
            as? Date {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day],
                                                     from: last)
            
            let year =  String(describing: components.year!)
            let month = String(describing: components.month!)
            let day = String(describing: components.day!)
            
            lastUsedLabel.isHidden = false
            lastUsedLabel.text = "Last visit: \(day)/\(month)/\(year) "
        }
    }
    
    // MARK: - Log in
    
    /// Focuses on the passwordTextField when return was pressed in
    /// emailAddressTextField.
    @IBAction func emailReturnDidTouch(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    /// Calls log in function when button is pressed.
    @IBAction func loginAction(_ sender: Any) {
        login(sender as AnyObject)
    }
    
    /// Log in.
    func login(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { user, error
                                in
                                
                                if (error == nil) {
                                    self.performSegueIfUser(user: user)
                                }
                                    
                                    // Show an alert with the login error.
                                else {
                                    self.errorMessage(
                                        title: "Failed to sign in", error: error!)
                                }
        }
    }
    
    /// Performs a segue when the log in has succeeded.
    func performSegueIfUser(user: FIRUser?) {
        if (user != nil) {
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
                                        
                                        FIRAuth.auth()!.createUser(
                                            withEmail: emailField.text!,
                                            password: passwordField.text!) {
                                                user, error in
                                                
                                                // Sign in when registration has succeeded.
                                                if (error == nil) {
                                                    FIRAuth.auth()!.signIn(
                                                        withEmail: self.emailTextField.text!,
                                                        password: self.passwordTextField.text!)
                                                }
                                                    // Show an alert with the register error.
                                                else {
                                                    self.errorMessage(
                                                        title: "Failed to register",
                                                        error: error!)
                                                }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { emailText in
            emailText.placeholder = "Email"
        }
        
        alert.addTextField { passwordText in
            passwordText.isSecureTextEntry = true
            passwordText.placeholder = "Password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Error
    
    /// Get the right error message to show in the alert.
    func errorMessage(title: String, error: Error) {
        if let err =
            FIRAuthErrorCode(rawValue: error._code) {
            
            var message = ""
            
            switch err {
            // Log in errors.
            case .errorCodeUserDisabled:
                message = "This account has been disabled."
                
            case .errorCodeWrongPassword:
                message = "This email address and password combination is wrong."

            
            // Register errors.
            case .errorCodeEmailAlreadyInUse:
                message = "There already exists an account with this email address."
                
            case .errorCodeWeakPassword:
                message = "The chosen password is too weak."
                
            // Errors for both.
            case .errorCodeInvalidEmail:
                message = "This is not a valid email address."

            default:
                message = "Something went wrong."
            }
            self.showErrorAlert(errorTitle: title, errorMessage: message)
        }
    }
    
    /// Shows the error alert.
    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message:
            errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(
            title: "Close", style: UIAlertActionStyle.default))
        
        present(alertController, animated: true)
    }
    
    // MARK: - State restoration
    
    /// Encodes the text in the emailTextField.
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(emailTextField.text, forKey: "restoredEmail")
        super.encodeRestorableState(with: coder)
    }
    
    /// Decodes and restores the text in the emailTextField.
    override func decodeRestorableState(with coder: NSCoder) {
        restoredEmail = coder.decodeObject(forKey: "restoredEmail") as! String?
        emailTextField.text = restoredEmail
        super.decodeRestorableState(with: coder)
    }
}
