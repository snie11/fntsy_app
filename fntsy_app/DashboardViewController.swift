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

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var bottomNav : UIImageView?
    @IBOutlet var newLeagueButton : UIButton?
    @IBOutlet var joinLeagueButton : UIButton?
    @IBOutlet var welcomeName : UILabel?
    private let refreshControl = UIRefreshControl()
    let cellReuseIdentifier = "LeagueCell"
    var email : String = ""
    @IBOutlet var tableView : UITableView!
    var dbManager : FirebaseDataManager?
    var resultleagues : [String] = []
    var selectedleague : String = ""
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var handle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    
//        let queue = DispatchQueue(label: "loadUsers")
        
        self.ref = Database.database().reference()
        refreshLeagues(refreshControl)
//        self.refreshControl.addTarget(self, action: #selector(self.refreshLeagues(_:)), for: .valueChanged)
        
        DispatchQueue.main.async{
            self.welcomeName?.text = "Welcome back!"
            self.backsplash?.image = UIImage(named: "upper_splash")
            self.bottomNav?.image = UIImage(named: "bottom_nav")
            self.welcomeName?.text = "Welcome back!"
            self.newLeagueButton?.setImage(UIImage(named:"􀁍"), for: .normal)
            self.joinLeagueButton?.setImage(UIImage(named:"􀜖"), for: .normal)
            print("email \(self.email)")
        }
        
//        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
//        signupButton?.setImage(UIImage(named:"signin_button"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("user:")
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
            tableView!.refreshControl = refreshControl
        } else {
            tableView!.addSubview(refreshControl)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return resultleagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = resultleagues[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "shield.fill")
        cell.imageView?.tintColor = UIColor.init(named: "green")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    private func refreshLeagues(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        getLeagues(sender)
    }
    
    private func getLeagues(_ sender: UIRefreshControl) {
//        self.resultleagues = ["Survivor Family League", "OT Fantasy League"]
        
        self.refHandle = self.ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
            if let leagues = snapshot.value as? [NSDictionary] {
                print("got leagues snapshoot")
                for league in leagues {
                    if let users = league["users"] as? [NSDictionary] {
                        print("got users")
                        for user in users {
                            if let em = user["email"] as? String {
                                if (em == self.email) {
                                    if let leagueCode = league["leaguename"] as? String {
                                        print(leagueCode)
                                        self.resultleagues.append(leagueCode)
                                    }
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
            }
        })
    }
}
