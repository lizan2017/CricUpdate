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
import SDWebImage

class PlayersMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var activvityIndicator: UIActivityIndicatorView!
    
    
    var databaseHandel:FIRDatabaseHandle!
    var databaseRef:FIRDatabaseReference!
  
    var playerArray:Array<[String:Any]> = []

    @IBOutlet weak var playersMenuCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        playersMenuCollectionView.dataSource = self
        playersMenuCollectionView.delegate = self
        
        let leftbutton = UIBarButtonItem(image: UIImage(named: "h6"), style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = leftbutton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        if self.revealViewController() != nil{
            leftbutton.target = self.revealViewController()
            leftbutton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 300.0
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }


        self.fetchPlayers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

   private func fetchPlayers() {
        self.activvityIndicator.startAnimating()
        self.activvityIndicator.hidesWhenStopped = true
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Players").observe(.value, with: {
            (snapshot) in
            self.activvityIndicator.stopAnimating()

            let snapshotData = snapshot.value as! NSDictionary
            let playersArray = snapshotData.allKeys as! Array<String>

            if self.playerArray.count > 0 {
              self.playerArray.removeAll()
            }

            for i:Int in 0 ..< playersArray.count{
                let playername = playersArray[i]
                let playerData = snapshotData[playername] as! [String:Any]
                self.playerArray.append(playerData)
            }
            self.playersMenuCollectionView.reloadData()
        })
    }
    
    func playersImageTapped() {
        
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

        let contentURl = URL(string: url)
        cell.playersImageView.sd_setImage(with: contentURl)
        cell.playerName.text = playerDic["Name"] as? String
        cell.playerCharacter.text = playerDic["Character"] as? String

        cell.playersImageView.layer.cornerRadius = 30.0
        cell.playersImageView.layer.borderColor = UIColor.white.cgColor
        cell.playerCharacter.textColor = UIColor.white
        cell.playerName.textColor = UIColor.white
        cell.playersImageView.layer.borderWidth = 1.0
        cell.playersImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playersImageTapped)))
        return cell
    }
}
