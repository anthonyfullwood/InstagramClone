//
//  CreateAccountViewController5.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 11/03/1401 AP.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewController5: UIViewController {

    var fullName: String?
    var emailAddress: String?
    var password: String?
    var birthday: String?
    var userId: String?
    private var userName = ""
    private let alert = AlertController()
    private let db = Firestore.firestore()
    private var ref: DocumentReference? = nil
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
    }
    

    //MARK: - Method for button pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        //Checks which button was pressed
        if sender.titleLabel?.text == k.buttonID.nextButtonId{
            //Check if user's username is valid or updates textField with error border if not valid
            if validateUserName(){
                //Check if user's email and password is not empty the tries to create account
                if emailAddress != "" && password != ""{
                    
                    createAccount()
                    
                }
                
                
            }else{
              
                usernameTextField.layer.borderWidth = 1
                usernameTextField.layer.borderColor = UIColor.red.cgColor
                usernameTextField.layer.cornerRadius = 5
                
            }
            
        }else{
    
            performSegue(withIdentifier: k.SIdentifiers.goToSignIn, sender: self)
        }
    }
    
    //MARK: - Validation method

    func validateUserName() -> Bool{
        if let username = usernameTextField.text{
            
            if username.count >= 6 && username.count <= 25 {
              
                self.userName = username.trimmingCharacters(in: .whitespaces)
                    
                return true
                
            }else{
                
                alert.showMessage(with: "Username must between 6 to 25 characters.")
                return false
                
            }
         
        }
        
        alert.showMessage(with: "Username field cannot be empty.")
        return false
    }
    
    //MARK: - Method for creating user's account with firebase
    func createAccount(){
        
        nextButton.titleLabel?.isHidden = true
        activityIndicator.startAnimating()
    
        Auth.auth().createUser(withEmail: emailAddress!, password: password!) { authResult, error in
          
            if let error = error {
    
                self.activityIndicator.stopAnimating()
                self.alert.showMessage(with: error.localizedDescription)
                return
                
            }
            
            self.userId  = Auth.auth().currentUser!.uid
            self.uploadUserInfo()
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: k.SIdentifiers.goToDashBoard, sender: self)
        }
    }
    
    //MARK: - Method for upload user info to firebase
    func uploadUserInfo(){
        //Add user's info to their firestore collection
        ref = db.collection(k.FStore.usersCollection).addDocument(data: [
            k.FStore.usernameField : userName.lowercased(),
            k.FStore.fullNameField: fullName,
            k.FStore.uidField : userId
            
       ]) { err in
           
           if let err = err {
               
               print("Error adding document: \(err.localizedDescription)")
               return
               
           } else {
               
               print("Document added with ID: \(self.ref!.documentID)")
           }
       }
    }
    
}


//MARK: - TextField delegate methods
extension CreateAccountViewController5: UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTextField.resignFirstResponder()
        return true
    }
    
}
