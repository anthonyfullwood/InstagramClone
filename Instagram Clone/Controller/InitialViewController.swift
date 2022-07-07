//
//  InitialViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 09/04/1401 AP.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
   
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToDashBoard", sender: self)
        }
    }

    

}
