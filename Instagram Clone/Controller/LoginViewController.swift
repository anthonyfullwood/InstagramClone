//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 11/03/1401 AP.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var emailAddress = ""
    private var password = ""
    private let alert = AlertController()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInPressed: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Method for button pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        //Check which button it is and performs action accordingly
        switch sender.titleLabel?.text{
            
        case k.buttonID.logIn:
            //Validates user credentials then calls login method
            if validateFields(){
                logIn()
            }
            
            break
            
        case k.buttonID.forgetPassword:
            
            break
            
        case k.buttonID.signUpdot:
            
            performSegue(withIdentifier: k.SIdentifiers.goToSignIn, sender: self)
            break
            
        default:
            break
        }
        
    }
    
    //MARK: - Validation method for user credentials
    func validateFields() -> Bool{
    
        if emailTextField.text != ""{
            emailAddress = emailTextField.text!
            
            if passwordTextField.text != ""{
                
                password = passwordTextField.text!
                return true
            }
        
            alert.showMessage(with: "Password field cannot be empty.")
            return false
        }
        
        alert.showMessage(with: "Email field cannot be empty.")
        return false
        
    }
    
    //MARK: - Method for loggin in user with firebase
    func logIn(){
        
        logInPressed.titleLabel?.isHidden = true
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) {authResult, error in
    
            if let error = error {
                let authError = error as NSError
                
                self.activityIndicator.stopAnimating()
                self.logInPressed.titleLabel?.isHidden = false
                
                self.alert.showMessage(with: authError.localizedDescription)
    
                return
            }
            
            self.performSegue(withIdentifier: "goToDashBoard", sender: self)
        }
    }
    
    
}

//MARK: - TextField delegate methods
extension LoginViewController: UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
