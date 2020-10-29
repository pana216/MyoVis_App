//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 09.07.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var myString = ""
    var ref:DatabaseReference?
    var myUsers = [User]()
    var selectedUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the database reference
        self.tableView.backgroundColor = darkBlue
        ref = Database.database().reference()
        
        // set the tableView
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func fetchData(){
        ref!.child("user/").observeSingleEvent(of: .value, with: {(snapshot) in
            if let users = snapshot.children.allObjects as? [DataSnapshot]{
                self.myUsers = []
                for user in users {
                    if let userData = user.value as? [String:Any]{
                        // name = user
                        let age = Int(userData["age"] as! String)!
                        let height = Int(userData["height"] as! String)!
                        let weight = Int(userData["weight"] as! String)!
                        let gender = userData["gender"] as! String
                        self.myUsers.append(User(name: user.key,
                                                 age: age,
                                                 weight: weight,
                                                 height: height,
                                                 gender: gender))
                    }
                }
            }// users
            // MARK: Important to reload the data here so the views reload as the data is retrieved fully
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })// ref
    }
    
    @IBAction func refreshTableView(_ sender: Any) {
        fetchData()
    }// Button
}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = midBlue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = myUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.setUserData(user: user.name, age: String(user.age), height: String(user.height), weight: String(user.weight), gender: user.gender)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.backgroundColor = midBlue
        selectedUser = myUsers[indexPath.row].name
        self.performSegue(withIdentifier: "showDateVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DateVC {
                destination.userName = selectedUser
        }
    }
}
