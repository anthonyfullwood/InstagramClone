//
//  PostsTableViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 07/04/1401 AP.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class PostsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var posts: [Post] = []
    var username: String?
    private let db = Firestore.firestore()
    private let alert = AlertController()
    private var userId = Auth.auth().currentUser!.uid
    private var postId: String?
    
    var postUserId: String?{
        didSet{
            
            if let postUserId = postUserId {
                loadPosts(with: postUserId)
            }
            
        }
    }
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonPressed))
        backButton.addGestureRecognizer(backTap)
        
        tableView.register(UINib(nibName: k.cellNibName, bundle: nil), forCellReuseIdentifier: k.cellIdentifier)
        
        usernameLabel.text = username
        
        
    }
    
    @objc func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadPosts(with docId: String){
        
        db.collection(k.FStore.postsCollection).document(postUserId!).collection(k.FStore.postsCollection).addSnapshotListener { querySnapshot, error in
            
            self.posts = []
            
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{
                
                if let querySnapshot = querySnapshot?.documents {
                    
                    for post in querySnapshot {
                        
                        let postData = post.data()
                        
                        if  let username = postData[k.FStore.usernameField] as? String,let postPhotoUrl = postData[k.FStore.postPhotoUrlField] as? String{
                            
                            var newPost = Post(id: post.documentID,postUserId: self.postUserId!,username: username,postPhotoUrl: postPhotoUrl)
                            
                            
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
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
            
        }
        
    }
    
    // MARK: - Table view data source
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
                
                if like == self.userId{
                    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostViewCell
        
        postUserId = cell.usersPostsId
        postId = cell.postId
        
        let usernameButton2Tap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfile))
        let usernameButton1Tap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfile))
        let optionsTap = UITapGestureRecognizer(target: self, action: #selector(self.showDeleteAlertSheet))
        
        cell.usernameButton1.addGestureRecognizer(usernameButton1Tap)
        cell.postUsername2.addGestureRecognizer(usernameButton2Tap)
        cell.optionsButton.addGestureRecognizer(optionsTap)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    @objc func goToProfile(){
        
        performSegue(withIdentifier: "goToUsersProfile", sender: self)
        
    }
    
    @objc func showDeleteAlertSheet(){
        
        
        
        if self.userId == postUserId{
            
            let deleteAlertSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { UIAlertAction in
                
                if let postUserId = self.postUserId, let postId = self.postId{
                    
                    
                    let postBrain = PostBrain(usersPostsId: postUserId, postDocId: postId)
                    
                    postBrain.deletePost()
                    
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            deleteAlertSheet.addAction(deleteAction)
            deleteAlertSheet.addAction(cancelAction)
            present(deleteAlertSheet, animated: true)
            
        }else{
            
            self.alert.showMessage(with: "Unfortunately developer fell asleep during the building of this module.")
            
        }
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! UsersProfileViewController
        
        destinationVC.profileUserId = postUserId
    }
}
