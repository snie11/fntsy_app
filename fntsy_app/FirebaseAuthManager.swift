//
//  FirebaseAuthManager.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/21/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func loginUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                print(error!)
                completionBlock(false)
            }
        }
    }
}
