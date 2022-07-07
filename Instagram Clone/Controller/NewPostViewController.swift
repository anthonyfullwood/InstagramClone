//
//  NewPostViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 18/03/1401 AP.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class NewPostViewController: UIViewController {

    var postImageUrl : URL?
    var postImage: UIImage?
    var caption: String?
    private let alert = AlertController()
    private let firebaseStorage = Storage.storage()
    private var ref: DocumentReference? = nil
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser!.uid
    private let date = Date()
    private var username = ""
    private var userPhotoUrl = ""
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        if let postImage = postImage {
            
            postImageView.image = postImage
            
        }

    }
    
    //MARK: - Method for loading user data before view is shown to user
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
    }
    
    //MARK: - Method to remove navigation bar before view disappears
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    

    //MARK: - Method for when share button is pressed
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        
        createPost()
        
    }
    
    //MARK: - Methods for loading user data from firebase
    func loadUserInfo(){
        
        db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: userId).addSnapshotListener { querySnapshot, error in
            
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{
                
                if let querySnapshot = querySnapshot?.documents.first {
                    
                    let data = querySnapshot.data()
                    
                    if let username  = data[k.FStore.usernameField] as? String{
        
                        self.username = username
                    }
                    
                    if let userPhotoUrl  = data[k.FStore.photoUrlField] as? String{
        
                        self.userPhotoUrl = userPhotoUrl
                    }
                                        
                }
            }
            
        }
    }
    
    //MARK: - Method for uplaoding post to firebase
    func createPost(){
        
        if  let caption = postCaptionTextField.text{
            self.caption = caption
        }
        
        navigationController?.navigationBar.isHidden = true
        postCaptionTextField.isEnabled = false
        
        activityIndicator.startAnimating()
        
        do{
            
            let fileName = String(date.timeIntervalSince1970)
            
            if let postImageUrl = postImageUrl {
                let storageReference =  firebaseStorage.reference().child(k.FStorage.postsFolder).child(userId).child(fileName)
            
                storageReference.putFile(from: postImageUrl) { storageMetadata, error in
                    storageReference.downloadURL(){ (url, error) in
                        if let error = error  {
                            self.alert.showMessage(with: error.localizedDescription)
                            
                            self.navigationController?.navigationBar.isHidden =  false
                            self.postCaptionTextField.isEnabled = true
                            self.activityIndicator.stopAnimating()
                            
                            return
                        }
                    
                        self.db.collection(k.FStore.postsCollection).document(self.userId).setData(["uid" : self.userId])
                        
                        let firestoreRef = self.db.collection(k.FStore.postsCollection).document(self.userId).collection(k.FStore.postsCollection).document()
                        
                        var data:[String: Any] = [:]
                        
                        if let caption = self.caption {
                            
                            data = [
                                k.FStore.postsIdField : firestoreRef.documentID,
                                k.FStore.usernameField : self.username,
                               k.FStore.captionField : caption,
                               k.FStore.postPhotoUrlField : url?.absoluteString,
                                k.FStore.dateField : fileName,
                           ]
                            
                        }else{
                            
                            data = [
                                k.FStore.postsIdField : firestoreRef.documentID,
                               k.FStore.usernameField : self.username,
                              k.FStore.postPhotoUrlField : url?.absoluteString,
                               k.FStore.dateField : fileName
                           ]
                            
                        }
                        
                        firestoreRef.setData(data)
                        
                        if self.userPhotoUrl != ""{
                            firestoreRef.updateData([k.FStore.userPhotoUrlField : self.userPhotoUrl])
                        }
                        
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                        
                    }
            
                }
                
            }else{
                self.navigationController?.navigationBar.isHidden =  false
                self.postCaptionTextField.isEnabled = true
                activityIndicator.stopAnimating()
                alert.showMessage(with: "Photo not found in path")
            }
            
        }

           
    }
    
}
