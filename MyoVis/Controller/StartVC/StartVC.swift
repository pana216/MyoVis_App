//
//  StartVC.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 23.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    @IBOutlet var userLbl: UITextField!
    @IBOutlet var ageLbl: UITextField!
    @IBOutlet var heightLbl: UITextField!
    @IBOutlet var weightLbl: UITextField!
    @IBOutlet var genderSegment: UISegmentedControl!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
  
    @IBAction func nextBtnPressed(_ sender: Any) {
        if !userLbl.text!.isEmpty && !ageLbl.text!.isEmpty && !weightLbl.text!.isEmpty && !heightLbl.text!.isEmpty {
            user = User(name:   userLbl.text!,
                        age:    Int(ageLbl.text!)!,
                        weight: Int(weightLbl.text!)!,
                        height: Int(heightLbl.text!)!,
                        gender: genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)!)
            self.user?.createUserDatapath()
            self.performSegue(withIdentifier: "showHelloUserVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HelloUserVC {
            destination.user = user
        }
    }
    
    // MARK: hide the keyboard
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
}


// MARK: keep the placeholder color white
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
