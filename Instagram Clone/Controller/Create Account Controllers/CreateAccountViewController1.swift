//
//  CreateAccountViewController1.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 09/03/1401 AP.
//

import UIKit
import ADCountryPicker

class CreateAccountViewController1: UIViewController {

    private var areaCode = "+1"
    private var phoneNumber = ""
    private var emailAddress = ""
    private var phoneSelected = true
    private let alert = AlertController()
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countryCodePicker: UIButton!
    @IBOutlet weak var messageLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true

    }

    @IBAction func actionPressed(_ sender: UIButton) {
        
        //Checks what sign up method was pressed and updates ui accordingly
        if sender.titleLabel?.text == k.signUpMethod.phone{
            
            phoneSelected = true
            phoneButton.alpha = 1
            phoneLine.alpha = 1
            emailButton.alpha = 0.5
            emailLine.alpha = 0.5
            countryCodePicker.isHidden = false
            messageLabel.isHidden = false
            textField.placeholder = "Phone number"
            emailAddress = ""
         
        }else if sender.titleLabel?.text == k.signUpMethod.email{
            
            phoneSelected = false
            phoneButton.alpha = 0.5
            phoneLine.alpha = 0.5
            emailButton.alpha = 1
            emailLine.alpha = 1
            countryCodePicker.isHidden = true
            messageLabel.isHidden = true
            textField.placeholder = "Email address"
            phoneNumber = ""
            
        }
    }
    
    //MARK: - Method for country picker button
    @IBAction func countryCodePickerPressed(_ sender: UIButton) {
        
        //Display country code picker
        let picker = ADCountryPicker(style: .grouped)
        picker.showFlags = false
        picker.searchBarBackgroundColor = UIColor.systemBackground
        picker.delegate = self
        navigationController?.pushViewController(picker, animated: true)
        
    }
    
    //MARK: - Method for next button
    @IBAction func nextPressed(_ sender: UIButton) {
       
        if let textFieldText = textField.text{
            
            //Checks what sign up method was used (phone or email)
            if phoneSelected{
                //Combines and stores country code and  phone number user entered
                phoneNumber = areaCode + textFieldText.trimmingCharacters(in: .whitespaces)
                
                //Performs segue if user's phone number is valid or updates textField with error border if not valid
                if validatePhoneNumber(value: phoneNumber){
                    
                    updateUiWithNoError()
                    performSegue(withIdentifier: k.SIdentifiers.goToConfirmation, sender: self)
                    
                }else{
                
                    updateUiWithError()
                }
            }else{
                
                //Stores email address user entered
                emailAddress = textFieldText.trimmingCharacters(in: .whitespaces)
                
                //Performs segue if phone number is valid or updates textField with error border if not valid
                if validateEmailAddress(value: emailAddress ){
                   
                    updateUiWithNoError()
                    performSegue(withIdentifier: k.SIdentifiers.goToAddName, sender: self)
               
                }else{
                    
                    updateUiWithError()
                    
                }
            }
            
        }else{
            
            //Displays an alert if user didnt enter any into textField
            alert.showMessage(with: "Field cannot be empty.")
        }
        
        
    }
    
    //MARK: -  Method for sign button
    @IBAction func signInPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: k.SIdentifiers.goToSignIn, sender: self)
        
    }
    
    //MARK: - Validation methods
    func validatePhoneNumber(value: String) -> Bool {
        if value.count > 10 && value.count < 15 {
            return true
        }else{
            alert.showMessage(with: "Please check your phone number and try again.")
            return false
        }
    }
    
    func validateEmailAddress(value: String) -> Bool {
        if value.count > 6 {
            return true
        }else{
            alert.showMessage(with: "Please check your email and try again.")
            return false
        }
    }
      
    //MARK: - Method for when validation method fails
    func updateUiWithError(){
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 5
    }
    
    //MARK: - Method for removing error
    func updateUiWithNoError(){
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5
    }
    
    //MARK: - Prepare for segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == k.SIdentifiers.goToConfirmation{
            //Passes phone number to next view controller
            let destinationVC = segue.destination as! ConfirmPhoneNumberViewController
            destinationVC.phoneNumber = phoneNumber
        }
        
        if segue.identifier == k.SIdentifiers.goToAddName{
            //Passes email address to next view controller
            let destinationVC = segue.destination as! CreateAccountViewController2
            destinationVC.emailAddress = emailAddress
        }
        
    }
}


//MARK: - ADCountryPicker delegate methods

extension CreateAccountViewController1: ADCountryPickerDelegate{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //Stores user's selected country code and updates ui
        areaCode = dialCode
        countryCodePicker.setTitle("\(code) \(dialCode)", for: .normal)
        navigationController?.popViewController(animated: true)
        
    }
}

//MARK: - TextField delegate methods
extension CreateAccountViewController1: UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.textField.resignFirstResponder()
        
        return true
    }
    
}


