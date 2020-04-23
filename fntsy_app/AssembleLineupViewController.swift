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

//struct League {
//    var leaguename : String
//    var leaguecode : String
//    var players : [Player]
//}
//
//struct Player {
//    var playername : String
//    var playerdescription : String
//    var points : [Int]
//}

class AssembleLineupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var newPlayerButton : UIButton?
    let cellReuseIdentifier = "PlayerCell"
    @IBOutlet var tableView : UITableView!
    var resultleagues : [String] = []
    @IBOutlet var backsplash : UIImageView?
    private let refreshControl = UIRefreshControl()
    @IBOutlet var inviteFriendsButton : UIButton?
    private var players : [Player] = []
    
    var email : String = ""
    var leaguename : String = ""
    var leaguecode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        backsplash?.image = UIImage(named: "upper_splash")
        newPlayerButton?.setImage(UIImage(named:"􀁍"), for: .normal)
        inviteFriendsButton?.setImage(UIImage(named:"invite_friends"), for: .normal)
    }
    
    @IBAction func onClick(_sender : UIButton) {
        let message = "Enter player name and description."
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addTextField(configurationHandler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            let name = alertController.textFields![0].text
            let description = alertController.textFields![1].text
            
            let player = Player(playername: name!, playerdescription: description!, points: [])
            dump(player)
            self.players.append(player)
            self.tableView.reloadData()
        }
        alertController.addAction(submitAction)
        self.present(alertController, animated: true, completion: nil)
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
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: cellReuseIdentifier)
        }
        cell?.textLabel?.text = players[indexPath.row].playername
        cell?.detailTextLabel?.text = players[indexPath.row].playerdescription
        cell?.imageView?.image = UIImage(systemName: "person")
        cell?.imageView?.tintColor = UIColor.init(named: "green")
        return cell!
    }
    
    private func refreshPlayers(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        getPlayers(sender)
    }
    
    private func getPlayers(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let league = League(leaguename: leaguename, leaguecode: leaguecode, players: players, users: [email])
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "AssembletoInvite" {
            // send whole league object
            
            let detailVC = destinationVC as! InviteFriendsViewController
            detailVC.league = league
//            detailVC.leaguename = leaguecode!.text!
            print("toInvite with \(email), \(leaguecode), \([players])")
        }
    }
}
