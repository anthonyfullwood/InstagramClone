//
//  ProfileCollectionViewCell.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 06/04/1401 AP.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Method for loading post image from firebase
    func loadPostImage(with photoUrl: String){
       
        DispatchQueue.global().async {
            
            if photoUrl != "" {
                
                let url = URL(string: photoUrl)
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    
                    if let image = data{
                        self.imageView.image = UIImage(data: image)
                    }
                    
                }
                
            }
        }
       
    }

}
