//
//  CreateAccountViewController3.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 11/03/1401 AP.
//

import UIKit

class CreateAccountViewController3: UIViewController {

    var fullName: String?
    var emailAddress: String?
    private var password = ""
    private let alert  = AlertController()
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Method for button pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        //Checks which button was pressed
        if sender.titleLabel?.text == k.buttonID.nextButtonId{
            //Performs segue if user's password is valid or updates textField with error border if not valid
            if validatePassword(){
             
                performSegue(withIdentifier: k.SIdentifiers.goToAddBirthday, sender: self)
                
            }else{
                
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.cornerRadius = 5
                
            }
            
            
        }else{
            
            performSegue(withIdentifier: "goToSignIn", sender: self)
        }
    }
    
    //MARK: - Validation method
    func validatePassword() -> Bool{
        if let password = passwordTextField.text{
            if password.count >= 8{
                self.password = password
                return true
            }else{
                alert.showMessage(with: "Password must be atleast 8 characters.")
                return false
            }
        }
        
        alert.showMessage(with: "Password field cannot be empty")
        return false
    }
    
    //MARK: - Prepare for segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == k.SIdentifiers.goToAddBirthday{
            //Passes full name and password to next view controller
            let destinationVC = segue.destination as! CreateAccountViewController4
            destinationVC.fullName = fullName
            destinationVC.password = password
            
            //Passes email address to next view controller if not empty
            if emailAddress != ""{
                destinationVC.emailAddress = emailAddress
            }
        }
        
    }
}

//MARK: - TextField delegate methods
extension CreateAccountViewController3: UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTextField.resignFirstResponder()
        return true
    }
    
}

