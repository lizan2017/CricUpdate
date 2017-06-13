//
//  SideMenuViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 5/31/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var emailID : [Email] = []
    var ref:FIRDatabaseReference!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var dataSource:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ["Player List","Feeds" , "Fixtures", "Log Out"]
        
        self.profileImage.layer.borderColor = UIColor.gray.cgColor
        self.profileImage.layer.borderWidth = 2.0
        self.profileImage.layer.cornerRadius = 50.0
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchUserData()
    }
    
    
   
  
    func fetchUserData(){
        
        ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: {
            (data) in
            let userData = data.value as! [String:String]
            
            self.userNameLabel.text = userData["First name"]
            
            self.emailLabel.text = userData["Email"]
        })
    }
    
    
    
    func fetchDataAndDelete(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do{
            emailID = try! context.fetch(Email.fetchRequest())
            let email = emailID[0]
            context.delete(email)
            try! context.save()
            let sb = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "loginVC")
            self.present(loginVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideMenuTableViewCell
        cell.menuItemLabel.text = dataSource[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.menuItemLabel.layer.cornerRadius = 20.0
        
        if cell.menuItemLabel.text == "Log Out" {
            cell.menuItemLabel.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
        if cell.menuItemLabel.text == "Log Out"{
            self.fetchDataAndDelete()
        }
        
        cell.isHighlighted = false
        cell.isSelected = false
        
        let sb = UIStoryboard(name: "PlayersMenu", bundle: nil)
        let playersMenuVC = sb.instantiateViewController(withIdentifier: "playersMenuVc")
        let nav = UINavigationController(rootViewController: playersMenuVC)
        self.revealViewController().pushFrontViewController(nav, animated: true)
        
    }

}
