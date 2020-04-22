//
//  FirebaseDataManager.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/21/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseDataManager : DataDelegate {
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var usernames : [String] = []
    var username : String = ""
    
    func setUsernames() {
        ref = Database.database().reference()
        refHandle = ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            if let users = snapshot.value as? [NSDictionary] {
                for user in users {
                    if let un = user["username"] as? String {
                        print("db \(un)")
                        self.usernames.append(un)
                    }
                }
            }
        })
    }
    
    func setUsername(email : String) {
        var result : String = "ERROR"
        ref = Database.database().reference()
        refHandle = ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            if let users = snapshot.value as? [NSDictionary] {
                for user in users {
                    if let em = user["email"] as? String, let un = user["username"] as? String {
                        if (em == email) {
                            result = un
                        }
                    }
                }
            }
        })
        username = result
    }
    
    func getUsernames() -> [String] {
        return usernames
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getLeagues(email : String) -> [String] {
        var resultleagues : [String] = []
        ref = Database.database().reference()
        refHandle = ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
            if let leagues = snapshot.value as? [NSDictionary] {
                for league in leagues {
                    if let users = league["users"] as? [NSDictionary] {
                        for user in users {
                            if let em = user["email"] as? String {
                                if (em == email) {
                                    if let leagueCode = league["leaguename"] as? String {
                                        resultleagues.append(leagueCode)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
        
        return resultleagues
    }
}
