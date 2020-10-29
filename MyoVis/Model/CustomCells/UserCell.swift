//
//  UserCell.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 20.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var userLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var heightLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    
    var myUser: User?

    func setUserData(user: String, age: String, height: String, weight: String, gender: String){
        self.userLbl.text = user
        self.ageLbl.text = age
        self.heightLbl.text = height
        self.weightLbl.text = weight
        self.genderLbl.text = gender
        
        myUser?.name = user
        myUser?.age = Int(age)!
        myUser?.height = Int(height)!
        myUser?.weight = Int(weight)!
        myUser?.gender = gender
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            contentView.backgroundColor = midBlue
    }
}
