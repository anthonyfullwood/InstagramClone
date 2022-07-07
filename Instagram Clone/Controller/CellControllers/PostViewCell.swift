//
//  PostViewCell.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 13/03/1401 AP.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostViewCell: UITableViewCell{
    
   
    var usersPostsId: String?
    var postId: String?
    var userLikedPost: Bool?
    var postLikesCount: Int?
    private let userId = Auth.auth().currentUser?.uid
    
    private let db = Firestore.firestore()
    private let alert = AlertController()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var postUsername2: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLikeButton: UIImageView!
    @IBOutlet weak var postCommentButton: UIImageView!
    @IBOutlet weak var postShareButton: UIImageView!
    @IBOutlet weak var usernameButton1: UILabel!
    @IBOutlet weak var usernameButton2: UILabel!
    @IBOutlet weak var doubleTapHeartImage: UIImageView!
    @IBOutlet weak var optionsButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        updateUI()
       
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - Method for adding tap gesture recognizer to view and updates ui
    func updateUI(){
       
        let postImageDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapLike))
        postImageDoubleTap.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(postImageDoubleTap)
        doubleTapHeartImage.layer.shadowColor = UIColor.label.cgColor
       
        let postLikeButtonTap = UITapGestureRecognizer(target: self, action: #selector(self.like))
        postLikeButton.addGestureRecognizer(postLikeButtonTap)
        
        let postCommentButtonTap = UITapGestureRecognizer(target: self, action: #selector(self.lazyDeveloper))
        postCommentButton.addGestureRecognizer(postCommentButtonTap)
        
        let postShareButtonTap = UITapGestureRecognizer(target: self, action: #selector(self.lazyDeveloper))
        postShareButton.addGestureRecognizer(postShareButtonTap)
        
        
       
        //Makes image view circular
        postUserImage.layer.borderWidth = 1
        postUserImage.layer.masksToBounds = false
        postUserImage.layer.borderColor = UIColor.systemGray5.cgColor
        postUserImage.layer.cornerRadius = postUserImage.frame.height / 2
        postUserImage.clipsToBounds = true
        
        
    }
    
    
    //MARK: - Method for loading post image from firebase
    func loadPostImage(with photoUrl: String){
        if postImage.image == nil{
            activityIndicator.startAnimating()
        }
        
        DispatchQueue.global().async {
            
            if photoUrl != "" {
                
                let url = URL(string: photoUrl)
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    
                    if let image = data{
                        self.postImage.image = UIImage(data: image)
                    }
                    
                }
                
            }
        }
       
    }
    
    //MARK: - Method for loading post user image from firebase
    func loadPostUserImage(with id: String){
        
        db.collection(k.FStore.usersCollection).whereField(k.FStore.uidField, isEqualTo: id).addSnapshotListener { querySnapshot, error in
            
            if let e = error{
                self.alert.showMessage(with: e.localizedDescription)
            }else{

                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let data = querySnapshot.data()
             
                    if let photoUrl = data[k.FStore.photoUrlField] as? String{
                        
                        DispatchQueue.global().async {
                        
                            let url = URL(string: photoUrl)
                            let data = try? Data(contentsOf: url!)
                            DispatchQueue.main.async {
                                
                                if let data = data{
                                    self.postUserImage.image = UIImage(data: data)
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
       
    }
    
    //MARK: - Method for when user double taps image
    @objc func doubleTapLike(){
    
        if let usersPostsId = usersPostsId, let postId = postId{
            let postBrain = PostBrain(usersPostsId: usersPostsId, postDocId: postId)
        
            if userLikedPost != nil{
                if !userLikedPost!{
                    postBrain.likePost()
                    self.postLikeButton.image = UIImage(systemName: "heart.fill")
                    self.postLikeButton.tintColor = UIColor.red
                }
            }
            
        }
       
        doubleTapHeartImage.isHidden = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.doubleTapHeartImage.isHidden = true
        }
        
    }
    
    //MARK: - Method for when user likes post
    @objc func like(){
        if let usersPostsId = usersPostsId, let postId = postId{
            
            let postBrain = PostBrain(usersPostsId: usersPostsId, postDocId: postId)
            
            if userLikedPost != nil{
                
                if userLikedPost! {
                    
                    postBrain.unlikePost()
                    
                    self.postLikeButton.image = UIImage(systemName: "heart")
                    self.postLikeButton.tintColor = UIColor.label
                    
                }else{
                    
                    postBrain.likePost()
                   
                    self.postLikeButton.image = UIImage(systemName: "heart.fill")
                    self.postLikeButton.tintColor = UIColor.red
                }
            }
            
            
        }
       
    }
    
 
    //MARK: - Method for displaying alert
    @objc func lazyDeveloper(){

        alert.showMessage(with: "Unfortunately developer fell asleep during the building of this module.")
    }
    
    

   
}
