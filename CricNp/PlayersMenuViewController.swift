//
//  PlayersMenuViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/7/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PlayersMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var activvityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var hamburgerMenu: UIBarButtonItem!
    var databaseHandel:FIRDatabaseHandle!
    var databaseRef:FIRDatabaseReference!
  
    var playerArray:Array<[String:Any]> = []

    @IBOutlet weak var playersMenuCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUserData()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        if self.revealViewController() != nil{
        hamburgerMenu.target = self.revealViewController()
        hamburgerMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
    }
    
    func sideMenuBar(){
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerArray = []
        

    }

    
  
    
    func fetchUserData(){
        self.activvityIndicator.startAnimating()
        self.activvityIndicator.hidesWhenStopped = true
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Players").observe(.value, with: {
            (snapshot) in
          let snapshotData = snapshot.value as! NSDictionary
        
        let playersArray = snapshotData.allKeys as! Array<String>
            for i:Int in 0 ..< playersArray.count{
                let playername = playersArray[i]
                
                let playerData = snapshotData[playername] as! [String:Any]
                
                
                self.playerArray.append(playerData)
                
            }
          
                    self.playersMenuCollectionView.delegate = self
                    self.playersMenuCollectionView.dataSource = self
            
            
            
          
        })
        
        
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return playerArray.count
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlayerMenuCollectionViewCell
        let playerDic = playerArray[indexPath.row]
        let url = playerDic["ImageURL"] as! String
//        let url = imageUrl[indexPath.row]
        let contentURl = URL(string: url)
        let data = try? Data(contentsOf: contentURl!)
        DispatchQueue.main.async {
            cell.playersImageView.image = UIImage(data: data!)
        }
        cell.playerName.text = playerDic["Name"] as? String
        cell.playerCharacter.text = playerDic["Character"] as? String

        cell.playersImageView.layer.cornerRadius = 30.0
        cell.playersImageView.layer.borderColor = UIColor.white.cgColor
        cell.playerCharacter.textColor = UIColor.white
        cell.playerName.textColor = UIColor.white
        cell.playersImageView.layer.borderWidth = 1.0
        self.activvityIndicator.stopAnimating()
        
        return cell
    }

    

}
