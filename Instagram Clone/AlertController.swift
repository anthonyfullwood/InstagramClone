//
//  AlertController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 12/03/1401 AP.
//

import Foundation
import UIKit

struct AlertController{
    
    //Method for displaying alert anywhere
    func showMessage(with message: String){
        let alert = UIAlertController(title:"Note" , message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alert, animated: true)
    }
}
