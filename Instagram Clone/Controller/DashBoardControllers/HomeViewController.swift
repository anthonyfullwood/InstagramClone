//
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 13/03/1401 AP.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private let alert = AlertController()
    private let refresh = UIRefreshControl()
    private let db = Firestore.firestore()
    private var posts: [Post]  = []
    private let userID = Auth.auth().currentUser!.uid
    private var postImage: UIImage?
    private var postImageUrl: URL?
    private var postUserID: String?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: k.cellNibName, bundle: nil), forCellReuseIdentifier: k.cellIdentifier)
        
        refresh.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
        tableView.addSubview(refresh)
        
        
    }
    
    //MARK: - Method for loading posts before view appears to user
    override func viewWillAppear(_ animated: Bool) {
        loadPosts()
    }
    
    //MARK: - Method for when user pressed add post button
    @IBAction func addPostButtonPressed(_ sender: UIBarButtonItem) {
        addPostAction()
    }
    
    //MARK: - Method for when user swipes down to reload post
    @objc func reloadPosts(){
        loadPosts()
    }
    
    //MARK: - Method that prompt user to select where they would like to get post photo from
    func addPostAction(){
        
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
    
    //MARK: - Method for displaying image picker
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    //MARK: - Methods for loading posts and likes from firebase
    func loadPosts(){
        
        
        db.collection(k.FStore.postsCollection)
            .addSnapshotListener { querySnapshot, error in
                
                self.posts = []
                
                if let e = error{
                    
                    self.alert.showMessage(with: e.localizedDescription)
                  
            
                }else{
                    
                    if let snapshotDocuments = querySnapshot?.documents{
                        
                        var docCount = 0
                        var firstLoad = false
                        firstLoad = true
                        
                        for doc in snapshotDocuments{
                            
                            
                            
                            let docId = doc.documentID
                            
                            self.db.collection(k.FStore.postsCollection).document(doc.documentID).collection(k.FStore.postsCollection).order(by: k.FStore.dateField,descending: true).addSnapshotListener { postsQuerySnapshot, error in
                                
                        
                                if let e = error{
                                    
                                    self.alert.showMessage(with: e.localizedDescription)
                                   
                              /*Checks if it is the first time posts are being loaded
                                so that it doesn't clear the posts array during each iteration*/
                                    
                                }else if !firstLoad {
                                    
                                    self.reloadPosts()
                                        
                                }else{
                                    
                                    docCount += 1
                                    
                                    /*Set firstLoad to false when all posts are loaded for the first time so that when a user likes a post the posts array can
                                        be cleared and reloaded and UI is updated */
                                    if docCount == snapshotDocuments.count{
                                        firstLoad = false
                                    }
                                  
                                    
                                    if let postsSnapshotDocuments = postsQuerySnapshot?.documents {
                                        
                                        for postsDoc in postsSnapshotDocuments{
                                            let postData = postsDoc.data()
                                            
                                            if  let username = postData[k.FStore.usernameField] as? String,let postPhotoUrl = postData[k.FStore.postPhotoUrlField] as? String{
                                                
                                                var newPost = Post(id: postsDoc.documentID,postUserId: docId,username: username,postPhotoUrl: postPhotoUrl)
                                                
                                                
                                                if let postCaption = postData[k.FStore.captionField] as? String{
                                                    newPost.caption = postCaption
                                                }
                                                
                                                if let likes  = postData["likes"] as? Array<String>{
                                                    newPost.likes = likes
                                                }
                                                
                                                self.posts.append(newPost)
                                                
                                            }
                                        }
                                      
                                        DispatchQueue.main.async {
            
                                            self.refresh.endRefreshing()
                                            self.tableView.reloadData()
                                            
                                        }
                                        
                                    }
                         
                                }
                            
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
            
            }
        
    }
    
}

//MARK: - Methods for table view data source
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! PostViewCell
        
        
        cell.postLikesCount = posts[indexPath.row].likes.count
        cell.postId = posts[indexPath.row].id
        cell.usersPostsId = posts[indexPath.row].postUserId
        cell.usernameButton1.text = posts[indexPath.row].username
        cell.usernameButton2.text = posts[indexPath.row].username
        
        
        if !posts[indexPath.row].caption.isEmpty{
            
            cell.postCaption.isHidden = false
            cell.postCaption.text = posts[indexPath.row].caption
            
        }else{
            
            cell.postCaption.isHidden = true
        }
        
        if posts[indexPath.row].likes.count != 0 {
            
            cell.postLikes.isHidden = false
            
            if posts[indexPath.row].likes.count == 1 {
                
                cell.postLikes.text = String(posts[indexPath.row].likes.count) + " Like"
                
            }else{
                
                cell.postLikes.text = String(posts[indexPath.row].likes.count) + " Likes"
            }
            
        }else{
            cell.postLikes.isHidden = true
        }
        
        
        if !posts[indexPath.row].likes.isEmpty{
            
            var userLiked = false
            
            for like in posts[indexPath.row].likes{
                
                if like == self.userID{
                    
                    cell.postLikeButton.image = UIImage(systemName: "heart.fill")
                    cell.postLikeButton.tintColor = UIColor.red
                    userLiked = true
                    
                    break
                    
                }else{
                    
                    cell.postLikeButton.image = UIImage(systemName: "heart")
                    cell.postLikeButton.tintColor = UIColor.label
                    
                }
            }
            
            if !userLiked{
                cell.postLikeButton.image = UIImage(systemName: "heart")
                cell.postLikeButton.tintColor = UIColor.label
            }
            
            cell.userLikedPost = userLiked
            
        }else{
            
            cell.userLikedPost = false
            cell.postLikeButton.image = UIImage(systemName: "heart")
            cell.postLikeButton.tintColor = UIColor.label
        }
        
        if posts[indexPath.row].postPhotoUrl != ""{
            cell.loadPostImage(with: posts[indexPath.row].postPhotoUrl)
        }
        
        
        
        if posts[indexPath.row].postUserId != ""{
            
            cell.loadPostUserImage(with: posts[indexPath.row].postUserId)
            
        }
        
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostViewCell
        
        postUserID = cell.usersPostsId
        
        let usernameButton2Tap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfile))
        let usernameButton1Tap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfile))
        
        
        cell.usernameButton1.addGestureRecognizer(usernameButton1Tap)
        cell.postUsername2.addGestureRecognizer(usernameButton2Tap)
        
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    @objc func goToProfile(){
        
        performSegue(withIdentifier: "goToUsersProfile", sender: self)
        
    }
    
    
}



//MARK: - Method for image picker delegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        postImageUrl = info[.imageURL] as? URL
        postImage = info[.originalImage] as? UIImage
        
        performSegue(withIdentifier: k.SIdentifiers.goToNewPost, sender: self)
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == k.SIdentifiers.goToNewPost{
            
            let destinationVC = segue.destination as! NewPostViewController
            //Passes image and image url to next view controller
            destinationVC.postImage = postImage
            destinationVC.postImageUrl = postImageUrl
        }
        
        if segue.identifier == "goToUsersProfile"{
            
            let destinationVC = segue.destination as! UsersProfileViewController
            //Passes post user id to next view controller
            
            destinationVC.profileUserId = postUserID
            
        }
        
    }
}

