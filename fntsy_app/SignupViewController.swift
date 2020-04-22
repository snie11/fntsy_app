//
//  SignupViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/15/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet var bg : UIImageView?
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var emailTextField : UITextField?
    @IBOutlet var nameTextField : UITextField?
    @IBOutlet var passwordTextField : UITextField?
    var passText: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "bg2")
        loginButton?.setImage(UIImage(named:"signin_button"), for: .normal)
    }
    
    @IBAction func createNewUser() {
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField?.text, let password = passwordTextField?.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                if (success) {
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.performSegue(withIdentifier: "toDashboard", sender: nil)
                    }))
                } else {
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                }
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "toDashboard" {
            print("toDashboard")
        }
        
//        else if segue.identifier == "toACVC" {
//            print("toDashboard")
//            let navVC = destinationVC as! UINavigationController
//            let addContactVC = navVC.topViewController as! AddContactViewController
//            addContactVC.delegate = self
//        }
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        passText = ((passText ?? "") as NSString).replacingCharacters(in: range, with: text)
//        return true
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        passwordTextField?.text = String(repeating: "*", count: (passwordTextField?.text ?? "").count)
//    }
//
}

