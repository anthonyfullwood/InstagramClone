//
//  UserViewCell.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 17/03/1401 AP.
//

import UIKit

class UserViewCell: UITableViewCell {
    

    var userId: String?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        //Makes image view circular
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.systemGray5.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK: - Method for loading image from firebase
    func loadPostUserImage(with url: String){
        
        DispatchQueue.global().async {
        
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(data: data!)
            }
                
        }
       
    }
    
}
