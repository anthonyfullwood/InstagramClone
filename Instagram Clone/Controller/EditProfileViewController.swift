//
//  EditProfileViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 18/03/1401 AP.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    var image: UIImage?
    private var imageUrl: URL?
    private var imageChanged = false
    private let alert = AlertController()
    private let firebaseStorage = Storage.storage()
    private var ref: DocumentReference? = nil
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser!.uid
    
    private var selectedField: String?
    private var selectedFieldValue: String?
    private var selectedDatabaseField: String?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        updateUI()
        
        
    }
    
    //MARK: - Method to load user details before view appears
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo(with: userId)
    }

    
    func updateUI(){
        
        navigationController?.navigationBar.isHidden = true
        
        //Makes image view circular
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.systemGray5.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
       
        if let image = image {
            userImageView.image = image
        }else{
          userImageView.image = UIImage(systemName: "person.fill")?.withTintColor(UIColor.white)
        }
        
        
        let fullNameFieldTap = UITapGestureRecognizer(target: self, action: #selector(self.fullNamefieldTapped))
        fullNameLabel.addGestureRecognizer(fullNameFieldTap)
        
        let usernameFieldTap = UITapGestureRecognizer(target: self, action: #selector(self.usernamefieldTapped))
        usernameLabel.addGestureRecognizer(usernameFieldTap)
        
        let bioFieldTap = UITapGestureRecognizer(target: self, action: #selector(self.biofieldTapped))
        bioLabel.addGestureRecognizer(bioFieldTap)
        
        
    }
    
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fullNamefieldTapped(){
        
        performAction(with: "fullName")
    }
    
    @objc func usernamefieldTapped(){
    
        performAction(with: "username")
    }

    @objc func biofieldTapped(){
        
        performAction(with: "bio")
    
        
    }

    
    func performAction(with field:String){
        
        switch field{
            
        case "fullName":
            
            selectedField = "Full Name"
            selectedFieldValue = fullNameLabel.text
            selectedDatabaseField = "fullName"
            
            break
            
        case "username":
            
            selectedField = "Username"
            selectedFieldValue = usernameLabel.text
            selectedDatabaseField = "username"
            break
            
        case "bio":
            
            selectedField = "Bio"
            selectedFieldValue = bioLabel.text
            selectedDatabaseField = "bio"
            
            break
            
        default:
            break
        }
        
        performSegue(withIdentifier: "goToEditProfileField", sender: self)
    }

    //MARK: - Method for when change profile button is pressed
    @IBAction func changeProfilePhotoPressed(_ sender: UIButton) {
        
        addPhotoAction()
    }
    
    //MARK: - Method for when done button is pressed
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        
        //Checks if image has been changes then performs action accordingly
        if imageChanged{
            
            uploadImage()
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Methods for loading profile data from firebase
    func loadUserInfo(with userId: String){
        
        db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: userId).addSnapshotListener { querySnapshot, error in
           
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{
               
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let data = querySnapshot.data()
                    
                    if let username  = data[k.FStore.usernameField] as? String, let fullName = data[k.FStore.fullNameField] as? String{
                
                        self.title = username
                        self.usernameLabel.text = username
                        self.fullNameLabel.text = fullName
                      
                    }
                    
                    
                    if let bio = data[k.FStore.bioField] as? String{
                        
                        self.bioLabel.text = bio
                        
                    }else{
                        
                        self.bioLabel.text = "Enter a bio"
                    
                    }
                }
                   
            }
            
        }
    }
    
    //MARK: - Method for when add post button is pressed
    func addPhotoAction(){
        
        let imagePickerOptionsAlert = UIAlertController(title: "Create a new post", message: "Choose a picture from library or camera.", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { UIAlertAction in
            
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true){
                
            }
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { UIAlertAction in
            
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true){
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerOptionsAlert.addAction(cameraAction)
        imagePickerOptionsAlert.addAction(libraryAction)
        imagePickerOptionsAlert.addAction(cancelAction)
        
        self.present(imagePickerOptionsAlert, animated: true)
        
    }
    
    //MARK: - Method for presenting image picker
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    //MARK: - Metho for uplaoding image and post details to firebase
    func uploadImage(){
        
        navigationController?.navigationBar.isHidden = true
        activityIndicator.startAnimating()
        
        do{
            
            let fileName = String("Picture")
            
            if let imageUrl = imageUrl {
                let storageReference =  firebaseStorage.reference().child(k.FStorage.profilePicsFolder).child(userId).child(fileName)
            
                storageReference.putFile(from: imageUrl) { storageMetadata, error in
                    storageReference.downloadURL(){ (url, error) in
                        if let error = error  {
                            self.alert.showMessage(with: error.localizedDescription)
                            return
                        }
                    
                        let firestoreRef = self.db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: self.userId)
                        
                        firestoreRef.getDocuments { querySnapshot, error in
                            
                            if (querySnapshot?.documents) != nil {
                                
                                let userDoc =  querySnapshot?.documents.first
                               
                                let data = ["photoUrl": url!.absoluteString]
                                
                                self.db.collection(k.FStore.usersCollection).document(userDoc!.documentID).updateData(data)
                            }
                            
                        }
                        
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                        
                    }
            
                }
            
            }else{
                activityIndicator.stopAnimating()
                alert.showMessage(with: "Photo not found in path")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! EditProfileFieldViewController
        
        if let selectedField = selectedField, let selectedFieldValue = selectedFieldValue {
            
            destinationVC.field = selectedField
            destinationVC.fieldValue = selectedFieldValue
            destinationVC.databaseField = selectedDatabaseField
        }
        
       
    }
}

//MARK: - Method for image picker delegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageUrl = info[.imageURL] as? URL
        image = info[.originalImage] as? UIImage
        
        userImageView.image = image
        
        imageChanged = true
       
        self.dismiss(animated: true)
    }
}
