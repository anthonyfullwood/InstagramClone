//
//  FollowUnfollowBrain.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 26/03/1401 AP.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct FollowUnfollowBrain {
    
    private let db = Firestore.firestore()
    let userId = Auth.auth().currentUser!.uid
    var usersProfileId: String
    

    init(usersProfileId: String){
        self.usersProfileId = usersProfileId
    }
    
    //MARK: - Method for following a user
    func followUser(){
        
        
        db.collection(k.FStore.usersCollection).whereField("userId", isEqualTo: usersProfileId).getDocuments { querySnapshot, error in
            
            if let e = error{
                
               print(e.localizedDescription)
                
            }else{
                
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let docId = querySnapshot.documentID
                    
                    db.collection(k.FStore.usersCollection).document(docId).updateData(["followers": FieldValue.arrayUnion([userId])])
    
                    
                }
            }
            
        }
        
        db.collection(k.FStore.usersCollection).whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            
            if let e = error{
                
               print(e.localizedDescription)
                
            }else{
                
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let docId = querySnapshot.documentID
                    
                    db.collection(k.FStore.usersCollection).document(docId).updateData(["following": FieldValue.arrayUnion([usersProfileId])])
    
                    
                }
            }
            
        }
        
        
    }
    
    //MARK: - Method for unfollowing a user
    func unfollowUser(){
        
        db.collection(k.FStore.usersCollection).whereField("userId", isEqualTo: usersProfileId).getDocuments { querySnapshot, error in
            
            if let e = error{
                
               print(e.localizedDescription)
                
            }else{
                
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let docId = querySnapshot.documentID
                    
                    db.collection(k.FStore.usersCollection).document(docId).updateData(["followers": FieldValue.arrayRemove([userId])])
    
                    
                }
            }
            
        }
        
        
        db.collection(k.FStore.usersCollection).whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            
            if let e = error{
                
               print(e.localizedDescription)
                
            }else{
                
                if let querySnapshot = querySnapshot?.documents.first{
                    
                    let docId = querySnapshot.documentID
                    
                    db.collection(k.FStore.usersCollection).document(docId).updateData(["following": FieldValue.arrayRemove([usersProfileId])])
    
                    
                }
            }
            
        }
    }
}
