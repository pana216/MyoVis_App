//
//  StageVC.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 21.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Firebase

class StageVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var location = ""
    var stage = ""
    let ref = Database.database().reference()
    var myStages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the tableView
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        self.tableView.backgroundColor = darkBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func fetchData(){
        ref.child("\(location)").observeSingleEvent(of: .value, with: {(snapshot) in
            if let stages = snapshot.children.allObjects as? [DataSnapshot] {
                self.myStages = []
                for stage in stages {
                    self.myStages.append(stage.key)
                }
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) // ref
    } // fetchData()
}

extension StageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = midBlue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stage = myStages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StageCell") as! LabelCell
        cell.setLbl(label: stage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stage = myStages[indexPath.row]
        self.performSegue(withIdentifier: "showChartVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChartVC {
            destination.location = location+stage+"/"
        }
    }
}
