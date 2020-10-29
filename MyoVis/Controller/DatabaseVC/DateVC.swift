//
//  UserDataVC.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 20.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Firebase

class DateVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var userName = ""
    var date = ""
    var type = ""
    let ref = Database.database().reference()
    var dates = [String]()
    var types = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = darkBlue
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func fetchData(){
        let ref = Database.database().reference()
        ref.child("user/\(userName)/measurement").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dates = snapshot.children.allObjects as? [DataSnapshot] {
                self.dates = []
                for date in dates {
                    self.dates.append(date.key)
                    if let types = date.value as? [String:Any] {
                        for type in types {
                            self.types.append(type.key)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })//ref
    }

}

extension DateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = midBlue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = dates[indexPath.row]
        let type = types[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateTypeCell") as! DateTypeCell
        cell.setLables(date: unixToDate(time: date),type: "Typ: \(type)" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        date = dates[indexPath.row]
        type = types[indexPath.row]
        self.performSegue(withIdentifier: "showStageVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StageVC {
            destination.location = "user/\(userName)/measurement/\(date)/\(type)/"
        }
    }
    
    
}
