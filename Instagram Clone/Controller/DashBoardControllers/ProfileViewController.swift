//
//  ProfileViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 16/03/1401 AP.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {

    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser!.uid
    private let alert = AlertController()
    private var postImageUrl: URL?
    private var postImage: UIImage?
    private var posts: [Post] = []
  
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var addPostImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCollectionViewCell")
        
        navigationController?.navigationBar.isHidden = true
     
        //Make image view circular
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.systemGray5.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
        
        let addPostPressed = UITapGestureRecognizer(target: self, action: #selector(self.addPostPressed))
        addPostImageView.addGestureRecognizer(addPostPressed)
        
        
        let menuPressed = UITapGestureRecognizer(target: self, action: #selector(self.menuPressed))
        
        menuButton.addGestureRecognizer(menuPressed)
        
    }
    
    //MARK: - Method for loading user data before view is shown to user
    override func viewWillAppear(_ animated: Bool) {
        
        loadUserInfo()
        loadPosts()
    }
    
    //MARK: - Method for when a button is clicked
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        //Checks what button was clicked and perfoms an action accordingly
        switch sender.titleLabel?.text{
            
        case k.buttonID.editProfile:
            
            performSegue(withIdentifier: k.SIdentifiers.goToEditProfile, sender: self)
            break
            
        case k.buttonID.viewArchive:
            
            alert.showMessage(with: "Unfortunately developer fell asleep during the building of this module.")
            break
            
        default:
            break
        }
    }
    
    @objc func menuPressed(){
        
        let alertSheet = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { UIAlertAction in
            
            self.signOut()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertSheet.addAction(logOutAction)
        alertSheet.addAction(cancelAction)
        
        self.present(alertSheet, animated: true)
        
    }
    
    func signOut(){
        
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }catch{
            alert.showMessage(with: "Failed to log out")
        }
        
    }
    
    //MARK: - Method for when add post button is pressed
    @objc func addPostPressed(){
        
        let imagePickerOptionsAlert = UIAlertController(title: "Create a new post", message: "Choose a picture from library.", preferredStyle: .actionSheet)
        
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { UIAlertAction in
            
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true){
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
    
    //MARK: - Methods for loading profile data from firebase
    func loadUserInfo(){
        
        db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: userId).addSnapshotListener { querySnapshot, error in
           
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{
               
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let data = querySnapshot.data()
                    
                    if let username  = data[k.FStore.usernameField] as? String, let fullName = data[k.FStore.fullNameField] as? String{
                
                        self.usernameLabel.text = username
                        self.fullNameLabel.text = fullName
     
                    }
                    
                    if let photoUrl = data[k.FStore.photoUrlField] as? String{
                        
                        self.loadImage(with: photoUrl)
                        
                    }
                    
                    if let bio = data[k.FStore.bioField] as? String{
                        
                        self.bioLabel.text = bio
                        
                    }else{
                        
                        self.bioLabel.text = ""
                    
                    }
                    
                    if let followers  = data["followers"] as? Array<String>{
                        
                        self.followersLabel.text = String(followers.count)
                        
                    }else{
                        
                        self.followersLabel.text = "0"
                    }
                    
                    if let following = data["following"] as? Array<String>{
                        
                        self.followingLabel.text = String(following.count)
 
                    }else{
                        self.followingLabel.text = "0"
                    }
                }
            }
            
        }
    }

    func loadImage(with url: String){
        
        DispatchQueue.global().async {
        
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let data = data{
                    self.userImageView.image = UIImage(data: data)
                }
                
            }
                
            
        }
       
    }
    
    func loadPosts(){
       
        db.collection(k.FStore.postsCollection).document(userId).collection(k.FStore.postsCollection).addSnapshotListener { querySnapshot, error in
            
            self.posts = []
            
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{
                
                if let querySnapshot = querySnapshot?.documents {
                   
                    self.postsLabel.text =  String(querySnapshot.count)
                    
                    for post in querySnapshot {
                        
                        let postData = post.data()
                        
                        if  let username = postData[k.FStore.usernameField] as? String,let postPhotoUrl = postData[k.FStore.postPhotoUrlField] as? String{
                            
                            var newPost = Post(id: post.documentID,postUserId: self.userId,username: username,postPhotoUrl: postPhotoUrl)
                            
                            
                            if let postCaption = postData[k.FStore.captionField] as? String{
                                newPost.caption = postCaption
                            }
                            
                            if let likes  = postData["likes"] as? Array<String>{
                                newPost.likes = likes
                            }
                            
                            self.posts.append(newPost)
                            self.collectionView.reloadData()
                    }
                    }
                    
                }else{
                    
                    self.postsLabel.text =  "0"
                    self.collectionView.reloadData()
                }
            }
            
           
        }
        
    }
    
}

//MARK: - Method for image picker delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        postImageUrl = info[.imageURL] as? URL
        postImage = info[.originalImage] as? UIImage
        
        performSegue(withIdentifier: k.SIdentifiers.goToNewPost, sender: self)
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == k.SIdentifiers.goToNewPost{
            let destinationVC = segue.destination as! NewPostViewController
            
            destinationVC.postImage = postImage
            destinationVC.postImageUrl = postImageUrl
        }
        
        if segue.identifier == k.SIdentifiers.goToEditProfile{
            let destinationVC = segue.destination as! EditProfileViewController
            
            destinationVC.image = self.userImageView.image
        }
        
        if segue.identifier == "goToPosts"{
            
            let destinationVC = segue.destination as! PostsViewController
            
            if let username = usernameLabel.text{
                
                destinationVC.username = username.uppercased()
            }
            
            destinationVC.postUserId = userId
           
        }
        
    }
}


extension ProfileViewController: UICollectionViewDelegate{
    
}

extension ProfileViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        
        if posts[indexPath.row].postPhotoUrl != "" {
            cell.loadPostImage(with: posts[indexPath.row].postPhotoUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToPosts", sender: self)
        
    }
    
}

/*extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
    
}*/
