//
//  UsersProfileViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 26/03/1401 AP.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UsersProfileViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private let alert = AlertController()
    private var postImageUrl: URL?
    private var postImage: UIImage?
    private var userId = Auth.auth().currentUser?.uid
    private var posts: [Post] = []
    var profileUserId: String?
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var viewArchiveButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCollectionViewCell")
        
        //Make image view circular
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.systemGray5.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let profileUserId = profileUserId {
            
            if profileUserId == userId{
                setCurrentUserButtons()
            }
            
            loadUserInfo(with: profileUserId)
            loadPosts(with: profileUserId)
        }
        
    }
   
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Method for when current user buttons are clicked
    @IBAction func currentUserButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func followFollowingPressed(_ sender: UIButton) {
      
        if let profileUserId = profileUserId {
            
            let followUnfollowBrain = FollowUnfollowBrain(usersProfileId: profileUserId)
            
            if sender.titleLabel?.text == "Follow"{
                
                followUnfollowBrain.followUser()
                
            }else if sender.titleLabel?.text == "Following"{
                
                followUnfollowBrain.unfollowUser()
            }
            
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
                
                        self.navBarTitle.title = username
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
                        
                        var following = false
                        
                        self.followersLabel.text = String(followers.count)
                        
                        for follower in followers{
                            
                            if follower == self.userId{
                              
                                self.updateButton(with: "following")
                                following = true
                                
                                break
                            }
                        }
                        
                        if !following{
                            
                            self.updateButton(with: "follow")
                        }
                        
                    }else{
                        
                        self.updateButton(with: "follow")
                        
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
    
    func loadPosts(with profileUserId: String){
       
        db.collection(k.FStore.postsCollection).document(profileUserId).collection(k.FStore.postsCollection).addSnapshotListener { querySnapshot, error in
            
            self.posts = []
            
            if let e = error{
                
                self.alert.showMessage(with: e.localizedDescription)
                
            }else{
                
                if let querySnapshot = querySnapshot?.documents {
                   
                    self.postsLabel.text =  String(querySnapshot.count)
                    
                    for post in querySnapshot {
                        
                        let postData = post.data()
                        
                        if  let username = postData[k.FStore.usernameField] as? String,let postPhotoUrl = postData[k.FStore.postPhotoUrlField] as? String{
                            
                            var newPost = Post(id: post.documentID,postUserId: self.profileUserId!,username: username,postPhotoUrl: postPhotoUrl)
                            
                            
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
                    self.posts = []
                }
            }
            
           
        }
        
    }
    
    func updateButton(with type: String){
        
        if self.profileUserId != self.userId{
            
            messageButton.isHidden = false
            
            if type == "follow"{
                
                self.followingButton.isHidden = true
                self.followButton.isHidden = false
                
            }else{
                
                self.followButton.isHidden = true
                self.followingButton.isHidden = false
                
            }
        }
        
       
    }
    
    func setCurrentUserButtons(){
        
        editProfileButton.isHidden = false
        viewArchiveButton.isHidden = false
    }

}

extension UsersProfileViewController: UICollectionViewDataSource{
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPosts"{
            
            let destinationVC = segue.destination as! PostsViewController
            destinationVC.postUserId = profileUserId
            destinationVC.username = navBarTitle.title?.uppercased()
        }
        
        
    }
    
}

extension UsersProfileViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
    
}
