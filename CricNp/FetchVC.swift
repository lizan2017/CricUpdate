//
//  FetchVC.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/1/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
class FetchVC: UIViewController , UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var playerNameTxt: UITextField!
    var playerArray:Array<String> = []
    var ref:FIRDatabaseReference!
    var handle:FIRDatabaseHandle?
    var keys:[String] = []
    
    @IBOutlet weak var playerDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerDataTableView.delegate = self
        playerDataTableView.dataSource = self
        ref = FIRDatabase.database().reference()
       
        handle = ref.child("Players").observe(.childAdded, with: {(playerItem) in
            
            if let item = playerItem.value as? String{
                let key = playerItem.key
                self.keys.append(key)
                self.playerArray.append(item)
                self.playerDataTableView.reloadData()
            }
            
        })
       
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveBtn(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        if playerNameTxt.text != ""{
            ref.child("Players").childByAutoId().setValue(playerNameTxt.text)
            playerNameTxt.text = ""
        }

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = playerArray[indexPath.row]
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        ref = FIRDatabase.database().reference().child("Players").child(keys[indexPath.row])
        ref.removeValue()
        self.playerArray.remove(at: indexPath.row)
        self.keys.remove(at: indexPath.row)
        self.playerDataTableView.deleteRows(at: [indexPath], with: .automatic)
    }
   

}
