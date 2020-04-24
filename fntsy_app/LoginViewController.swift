//
//  LoginViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/15/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var bg : UIImageView?
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var emailTextField : UITextField?
    @IBOutlet var passwordTextField : UITextField?
    var username : String = ""
    var passText: String?
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "bg2")
        emailTextField!.text = "selina.nie11@gmail.com"
        passwordTextField!.text = "hello123"
        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
        emailTextField?.autocorrectionType = .no
        passwordTextField?.autocorrectionType = .no
        passwordTextField?.isSecureTextEntry = true
        ref = Database.database().reference()
    }
    
    @IBAction func loginUser() {
        let loginManager = FirebaseAuthManager()
//        let dbManager = FirebaseDataManager()
        if let email = emailTextField?.text, let password = passwordTextField?.text {
            loginManager.loginUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
//                    dbManager.setUsername(email: email)
//                    self.username = dbManager.getUsername()
                    self.performSegue(withIdentifier: "loginToDashboard", sender: nil)
                } else {
                    message = "Incorrect email or password."
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        var usrnm : String = ""
        
        if segue.identifier == "loginToDashboard" {
            let detailVC = destinationVC as! DashboardViewController
            detailVC.email = emailTextField!.text!
            print("toDashboard with email \(username)")
        }
        
        
//        else if segue.identifier == "toACVC" {
//            print("toDashboard")
//            let navVC = destinationVC as! UINavigationController
//            let addContactVC = navVC.topViewController as! AddContactViewController
//            addContactVC.delegate = self
//        }
    }
}
