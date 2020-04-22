//
//  DashboardViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/15/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class DashboardViewController: UIViewController{

    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var bottomNav : UIImageView?
    @IBOutlet var newLeagueButton : UIButton?
    @IBOutlet var joinLeagueButton : UIButton?
    @IBOutlet var welcomeName : UILabel?
    private let refreshControl = UIRefreshControl()
    var email : String = ""
    @IBOutlet var table : UITableView?
    var dbManager : FirebaseDataManager
    var resultleagues : [String] = []
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var handle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backsplash?.image = UIImage(named: "upper_splash")
        bottomNav?.image = UIImage(named: "bottom_nav")
        self.welcomeName?.text = "Welcome back!"
//        dbManager = FirebaseDataManager()
        ref = Database.database().reference()
        refreshControl.addTarget(self, action: #selector(refreshLeagues(_:)), for: .valueChanged)
        print("email \(email)")
    
//        let dispatchQueue = DispatchQueue(label: "loadUsers", qos: .background)
//        dispatchQueue.async{
//            self.welcomeName?.text = "Welcome back!"
//        }
        
//        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
//        signupButton?.setImage(UIImage(named:"signin_button"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            dump(user!);
//          self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        refreshLeagues(sender)
    }
    
    func setupTableView() {
        if #available(iOS 10.0, *) {
            table!.refreshControl = refreshControl
        } else {
            table!.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshLeagues(_ sender: Any) {
        getLeagues()
    }
    
    private func getLeagues() {
        DispatchQueue.main.async {
            self.refHandle = self.ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
                if let leagues = snapshot.value as? [NSDictionary] {
                    for league in leagues {
                        if let users = league["users"] as? [NSDictionary] {
                            for user in users {
                                if let em = user["email"] as? String {
                                    if (em == self.email) {
                                        if let leagueCode = league["leaguename"] as? String {
                                            self.resultleagues.append(leagueCode)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}
