//
//  EditPointsViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/23/20.
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

class EditPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var league : League?
    var leagueid : Int?
    let cellReuseIdentifier = "PlayerPointsCell"
    @IBOutlet var tableView : UITableView!
    @IBOutlet var backsplash : UIImageView?
    private let refreshControl = UIRefreshControl()
    var currPlayer : Player?
    var playerid : Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        backsplash?.image = UIImage(named: "upper_splash")
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
        return league!.players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.deselectRow(at: indexPath, animated: true)
        playerid = indexPath.row
        currPlayer = league!.players[indexPath.row]
        self.performSegue(withIdentifier: "PointsToPlayer", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = league!.players[indexPath.row].playername
        cell.imageView?.image = UIImage(systemName: "person")
        cell.imageView?.tintColor = UIColor.init(named: "green")
        if let label1 = cell.viewWithTag(9) as? UILabel {
            print("making cell detail \(league!.players[indexPath.row].playername)")
             label1.text = "\(league!.players[indexPath.row].totalpoints) points"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "PointsToPlayer" {
            // send whole league object
            
            let detailVC = destinationVC as! PlayerDetailViewController
            detailVC.league = league
            detailVC.leagueid = leagueid
            detailVC.playerid = playerid
            detailVC.currPlayer = currPlayer
//            detailVC.leaguename = leaguecode!.text!
            print("toPlayer")
        }
    }
}
