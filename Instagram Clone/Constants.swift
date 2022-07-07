//
//  Constants.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 13/03/1401 AP.
//

import Foundation

struct k {
    
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "PostViewCell"
    static let userCellIdentifier = "UserReusableCell"
    static let userCellNibName = "UserViewCell"
    
    struct signUpMethod{
        static let phone = "Phone"
        static let email = "Email"
    }
    
    struct SIdentifiers{
        static let goToConfirmation = "goToConfirmation"
        static let goToAddName = "goToAddName"
        static let goToSignIn = "goToSignIn"
        static let goToCreatePassword = "goToCreatePassword"
        static let goToAddBirthday = "goToAddBirthday"
        static let goToCreateUsername = "goToCreateUsername"
        static let goToDashBoard = "goToDashBoard"
        static let goToChangePhoneNumber = "goToChangePhoneNumber"
        static let goToNewPost = "goToNewPost"
        static let goToEditProfile = "goToEditProfile"
    }
    
    struct buttonID{
        static let nextButtonId = "Next"
        static let changePhoneNumber = "Change phone number"
        static let resendSMS = "Resend SMS"
        static let logIn = "Log in"
        static let forgetPassword = "Forget password"
        static let signUpdot = "Sign Up."
        static let editProfile = "Edit Profile"
        static let viewArchive = "View Archive"
    }
    
    struct FStore{
        static let usersCollection = "users"
        static let postsCollection = "posts"
        static let postsIdField = "id"
        static let postsLikesCollection = "likes"
        static let postPhotoUrlField = "postPhotoUrl"
        static let userPhotoUrlField = "userPhotoUrl"
        static let photoUrlField = "photoUrl"
        static let dateField = "date"
        static let usernameField = "username"
        static let uidField = "userId"
        static let fullNameField = "fullName"
        static let likesField = "likes"
        static let captionField = "caption"
        static let bioField = "bio"
        static let followersCollection = "followers"
        static let followingCollection = "following"
    }
    
    struct FStorage{
        static let postsFolder = "Posts"
        static let profilePicsFolder = "ProfilePics"
    }
}
