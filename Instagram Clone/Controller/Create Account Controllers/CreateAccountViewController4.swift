//
//  CreateAccountViewController4.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 11/03/1401 AP.
//

import UIKit

class CreateAccountViewController4: UIViewController{

    var fullName: String?
    var emailAddress: String?
    var password: String?
    private var birthday = ""
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        setBirthday()
    
    }
    
    //MARK: - Method for next button
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        //Performs segue if user's birthday is valid or updates textField with error border if not valid
        if validateBirthday(){
          
            performSegue(withIdentifier: k.SIdentifiers.goToCreateUsername, sender: self)
            
        }else{
            
            birthdayTextField.layer.borderWidth = 1
            birthdayTextField.layer.borderColor = UIColor.red.cgColor
            birthdayTextField.layer.cornerRadius = 5
            
        }
    }
    
    //MARK: - DatePicker method
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        setBirthday()
    }
    
    //MARK: - Method for setting date in textField
    func setBirthday(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        birthdayTextField.text = date
        birthday = date
        
    }
    
    //MARK: - Validation method
    func validateBirthday() -> Bool{
        return true
    }
    
    //MARK: - Prepare for segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Passes full name and password to next view controller
        let destinationVC = segue.destination as! CreateAccountViewController5
        destinationVC.fullName = fullName
        destinationVC.password = password
        
        //Passes email address to next view controller if not empty
        if emailAddress != ""{
            destinationVC.emailAddress = emailAddress
        }
    }
}
