//
//  ForgetPasswordViewController.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 13/04/1401 AP.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backToLoginPressed(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
