//
//  PlayerDetailViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/23/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import UIKit
import Firebase

protocol PointRefresher: class {
    func refreshPoints()
}

class PlayerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var leagueid : Int?
    var playerid : Int?
    let cellReuseIdentifier = "PointsCell"
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var team : UITextField!
    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var card : UIImageView?
    @IBOutlet var saveButton : UIButton?
    @IBOutlet var addButton : UIButton?
    private let refreshControl = UIRefreshControl()
    var currPlayer : Player?
    var league : League?
    var selectedTeam : String?
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    weak var delegate: PointRefresher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        backsplash?.image = UIImage(named: "upper_splash")
        card?.image = UIImage(named: "white_card")
        saveButton?.setImage(UIImage(named:"save_changes"), for: .normal)
        addButton?.setImage(UIImage(named:"􀁍"), for: .normal)
        createPickerView()
        dismissPickerView()
        ref = Database.database().reference()
        currPlayer = league!.players[playerid!]
    }
    
    @IBAction func onClick(_sender : UIButton) {
        let message = "Enter points."
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            if let points : Int = Int(alertController.textFields![0].text!) {
               print("leagueid: \(self.leagueid!)")
                print("playerid: \(self.playerid!)")
                print("pointsnum: \((self.currPlayer?.points)!.count)")
                self.ref.child("leagues").child("\(self.leagueid!)").child("players").child("\(self.playerid!)").child("pts").child("\((self.currPlayer?.points)!.count)").setValue(["pts":points])
                
                self.currPlayer?.points.append(points)
                self.currPlayer?.totalpoints += points
                self.ref.child("leagues").child("\(self.leagueid!)").child("players").child("\(self.playerid!)").child("totalpts").setValue(self.currPlayer!.totalpoints)
                
                self.tableView.reloadData()
                self.delegate?.refreshPoints()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_sender : UIButton) {
        var usrnm : String = ""
        if let test = self.selectedTeam as? String {
            print(self.selectedTeam!)
            refHandle = ref.child("users").observe(DataEventType.value, with: { (snapshot) in
                if let users = snapshot.value as? [NSDictionary] {
                    for user in users {
                        if let email = user["email"] as? String, let username = user["username"] as? String {
                            if (email == self.selectedTeam!) {
                                usrnm = username
                                print(usrnm)
                                self.ref.child("leagues").child("\(self.leagueid!)").child("players").child("\(self.playerid!)").child("team").setValue(usrnm)
                            }
                        }
                    }
                }
            })
        }
    }

    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           team.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: false)
       toolBar.isUserInteractionEnabled = true
       team?.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (league?.users.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return league?.users[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTeam = league?.users[row]
        team.text = selectedTeam
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
        return (currPlayer?.points.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = "Week \(indexPath.row)"
        cell.detailTextLabel?.text = "\(currPlayer!.points[indexPath.row])"
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
        if segue.identifier == "PlayerToDetail" {
            // send whole league object
            
            let detailVC = destinationVC as! EditPointsViewController
            detailVC.league = league
            detailVC.leagueid = leagueid
//            detailVC.leaguename = leaguecode!.text!
            print("back to points")
        }
    }
}
