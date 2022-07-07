//
//  ConfirmPhoneNumberViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 10/03/1401 AP.
//

import UIKit
import FirebaseAuth

class ConfirmPhoneNumberViewController: UIViewController{
    
    private let alert = AlertController()
    var phoneNumber: String?{
        didSet{
            
            sendVerifcationCode()
            
        }
    }
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var confirmationCodetextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        //Adds phone number to heading
        if let phoneNumber = phoneNumber {
            titleTextView.text += " \(phoneNumber)"
        }
        
    }
    
    //MARK: - Method for button pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        //Checks which button was pressed then performs actions accordingly
        switch sender.titleLabel?.text{
            
        case k.buttonID.changePhoneNumber:
            
            performSegue(withIdentifier: k.SIdentifiers.goToChangePhoneNumber, sender: self)
            break
            
        case k.buttonID.resendSMS:
            
            sendVerifcationCode()
            break
            
        case k.buttonID.nextButtonId:

            checkConfirmationCode()
            break
            
        default:
            break
        }
    }
    
    //MARK: - Method for sending verification code to user's number
    func sendVerifcationCode(){
        
        if let phoneNumber = phoneNumber {
            
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                }
            
        }
        
    }
    
    //MARK: - Method for checking if confirmation code entered by user is correct
    func checkConfirmationCode(){
        
        if let verificationCode = confirmationCodetextField.text{
            
            if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID"){
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID,
                    verificationCode: verificationCode
                )
                
                //Signs in user with phone number
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                    
                        let authError = error as NSError
                        
                        self.alert.showMessage(with: authError.localizedDescription)
            
                        return
                    }
                    
                    self.performSegue(withIdentifier: k.SIdentifiers.goToAddName, sender: self)
                    
                }
            }
            
        }else{
            
            self.alert.showMessage(with: "Confirmation code field cannot be empty")
            confirmationCodetextField.layer.borderWidth = 1
            confirmationCodetextField.layer.borderColor = UIColor.red.cgColor
            confirmationCodetextField.layer.cornerRadius = 5
        }
        
    }
    
    
    
}

//MARK: - TextField delegate method
extension ConfirmPhoneNumberViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        confirmationCodetextField.resignFirstResponder()
        return true
    }
    
}


