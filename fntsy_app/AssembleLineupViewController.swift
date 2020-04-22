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

class AssembleLineupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var newPlayerButton : UIButton?
    let cellReuseIdentifier = "PlayerCell"
    @IBOutlet var tableView : UITableView!
    var resultleagues : [String] = []
    @IBOutlet var backsplash : UIImageView?
    private let refreshControl = UIRefreshControl()
    
    var selectedleague : String = ""
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        backsplash?.image = UIImage(named: "upper_splash")
        newPlayerButton?.setImage(UIImage(named:"􀁍"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            print("user:")
//            dump(user!);
////          self.tableView.reloadData()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        return cell
    }
    
    private func refreshPlayers(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        getPlayers(sender)
    }
    
    private func getPlayers(_ sender: UIRefreshControl) {

    }
}
