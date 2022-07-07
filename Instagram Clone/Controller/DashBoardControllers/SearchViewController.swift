//
//  SearchViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 16/03/1401 AP.
//

import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController{
    
    private var users : [User] = []
    private let db = Firestore.firestore()
    private let alert = AlertController()
    var searchUserId: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
        tableView.register(UINib(nibName: k.userCellNibName, bundle: nil), forCellReuseIdentifier: k.userCellIdentifier)
    }
    

}

//MARK: - Search bar methods
extension SearchViewController: UISearchBarDelegate{
    
 
//Loads the users from firebase that match the search text user entered
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

     db.collection(k.FStore.usersCollection).whereField(k.FStore.usernameField, isEqualTo: searchBar.text!.lowercased()).getDocuments { querySnapshot, error in
         
         self.users = []
         
         if let e = error{
             self.alert.showMessage(with: e.localizedDescription)
         }else{
             
             if let snapshotDocuments = querySnapshot?.documents{
                 for doc in snapshotDocuments {
                    
                     let data = doc.data()
                     
                     var userPhotoUrl = ""
                     
                     if let searhUserPhotoUrl = data[k.FStore.photoUrlField] as? String{
                         userPhotoUrl = searhUserPhotoUrl
                     }
                     
                     if let userId = data[k.FStore.uidField] as? String, let username = data[k.FStore.usernameField] as? String, let fullName = data[k.FStore.fullNameField] as? String{
                         
                         let newUser = User(userId: userId, username: username, fullName: fullName, photoUrl: userPhotoUrl)
                         
                         self.users.append(newUser)
                         
                         DispatchQueue.main.async {
                             self.tableView.reloadData()
                         }
                     }
                     
                 }
             }
         }
         
     }
     
 
 }
 
//Clear users loaded when searhBar text is empty
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0{
      
        users = []
        tableView.reloadData()
 
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
 
        }
    }
 }

//MARK: - TableView Methods
extension SearchViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k.userCellIdentifier, for: indexPath) as! UserViewCell
      
        
        cell.userId = users[indexPath.row].userId
        cell.usernameLabel.text = users[indexPath.row].username
        cell.fullNameLabel.text = users[indexPath.row].fullName
        
        if users[indexPath.row].photoUrl != ""{
           
            cell.loadPostUserImage(with: users[indexPath.row].photoUrl)
        }else{
            cell.userImageView.image = UIImage(systemName: "person.fill")?.withTintColor(UIColor.white)
        }
        return cell
    }
    
    
}

//MARK: - Table view delegate methods
extension SearchViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserViewCell
        
        self.searchUserId = cell.userId
        
        performSegue(withIdentifier: "goToUsersProfile", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! UsersProfileViewController
        
        destinationVC.profileUserId = self.searchUserId
    }
}

