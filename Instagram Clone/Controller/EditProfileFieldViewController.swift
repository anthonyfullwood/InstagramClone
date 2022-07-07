//
//  EditProfileFieldViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 01/04/1401 AP.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileFieldViewController: UIViewController {
    
    var field: String?
    var fieldValue: String?
    var databaseField: String?
    private let alert = AlertController()
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser!.uid
    

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        
        if let field = field, let fieldValue = fieldValue {
            
            fieldLabel.text = field
            textField.text = fieldValue
            navBar.title = field
        }

        
    }
    

    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        
        if validateField(){
            
                doneButton.isEnabled = false
                activityIndicator.startAnimating()
                
                db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: userId).getDocuments { querySnapshot, error in
                   
                    if let e = error{
                        
                        self.alert.showMessage(with: e.localizedDescription)
                        self.activityIndicator.stopAnimating()
                        
                        self.doneButton.isEnabled = true
                        
                    }else{
                       
                        if let querySnapshot = querySnapshot?.documents.first{
                            
                            let docId = querySnapshot.documentID
                          
                            if let databaseField = self.databaseField {
                                
                                
                                let data = [databaseField : self.fieldValue]
                                
                                self.db.collection(k.FStore.usersCollection).document(docId).updateData(data)
                                
                                self.activityIndicator.stopAnimating()
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            
                        }
                           
                    }
                    
                }
           
        }
        
    }
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateField() -> Bool{
        
        if let text = textField.text{
            
            if text.count >= 6{
                fieldValue = text.trimmingCharacters(in: .whitespaces)
                return true
                
            }else{
            
                alert.showMessage(with: "Field must consist of atleast 6 characters.")
                return false
                
            }
            
        }
        
        alert.showMessage(with: "Field cannot be empty.")
        return false
    }
    
}
