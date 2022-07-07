//
//  CreateAccountViewController2.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 11/03/1401 AP.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController2: UIViewController {
    
    private var fullName = ""
    private let alert = AlertController()
    var emailAddress: String?
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
    }
    

    //MARK: - Method for next button
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        //Performs segue if user's full name is valid or updates textField with error border if not valid
        if validateFullName(){
            
            performSegue(withIdentifier: k.SIdentifiers.goToCreatePassword, sender: self)
            
        }else{
            
            fullNameTextField.layer.borderWidth = 1
            fullNameTextField.layer.borderColor = UIColor.red.cgColor
            fullNameTextField.layer.cornerRadius = 5
        }
        
    }
    
    //MARK: - Validation method
    func validateFullName() -> Bool{
        
        if let name = fullNameTextField.text{
            
            if name.count >= 6{
                fullName = name.trimmingCharacters(in: .whitespaces)
                return true
                
            }else{
            
                alert.showMessage(with: "Name must consist of atleast 6 characters.")
                return false
                
            }
            
        }
        
        alert.showMessage(with: "Full name field cannot be empty.")
        return false
    }
    
    //MARK: - Prepare for segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Passes full name to next view controller
        let destinationVC = segue.destination as! CreateAccountViewController3
        destinationVC.fullName = fullName
        
        //Passes email address to next view controller if not empty
        if emailAddress != ""{
            destinationVC.emailAddress = emailAddress
        }
    }

}

//MARK: - TextField delegate methods
extension CreateAccountViewController2: UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        fullNameTextField.resignFirstResponder()
        return true
    }
    
}
