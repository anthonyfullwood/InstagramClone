//
//  PostsBrain.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 14/03/1401 AP.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostBrain{
    
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser!.uid
    private var usersPostsId: String
    private var postDocId: String

    init(usersPostsId: String,postDocId: String){
        self.usersPostsId = usersPostsId
        self.postDocId = postDocId
    }
    
    //MARK: - Method for uploading post like to firebase
    func likePost(){
        
        db.collection(k.FStore.postsCollection).document(usersPostsId).collection(k.FStore.postsCollection).document(postDocId).updateData(["likes": FieldValue.arrayUnion([userId]) ])
    }
    
    //MARK: - Method for deleting post like from firebase
    func unlikePost(){
        
        db.collection(k.FStore.postsCollection).document(usersPostsId).collection(k.FStore.postsCollection).document(postDocId).updateData(["likes": FieldValue.arrayRemove([userId]) ])
    }
    
    //MARK: - Method for deleting post from firebase
    func deletePost(){
        db.collection(k.FStore.postsCollection).document(userId).collection(k.FStore.postsCollection).document(postDocId).delete()
    }
}
