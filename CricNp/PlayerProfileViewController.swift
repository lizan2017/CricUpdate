//
//  PlayerProfileViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
class PlayerProfileViewController: UIViewController {
    @IBOutlet weak var playerImageView: UIImageView!

    @IBOutlet weak var playerCharacterLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    var imageUrl:String?
    var playerName:String?
    var playerCharacter:String?
    var databaseRef:FIRDatabaseReference!
    var playersArray:Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Player's Profile"
        fetchFavPlayers()
        
        // Do any additional setup after loading the view.
        
        playerImageView.layer.cornerRadius = 75.0
        let url = URL(string: imageUrl!)
        playerImageView.sd_setImage(with: url)
        playerCharacterLabel.text = playerCharacter
        playerNameLabel.text =  playerName
        
        favBtn.addTarget(self, action: #selector(setFaviouritePlayers), for: .touchUpInside)
        
        
    }
    
    func fetchFavPlayers(){
        self.databaseRef = FIRDatabase.database().reference()
        
        self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("favourites").observe(.value, with: {
            (snapshot) in
            if snapshot.value is NSNull{
                
                }else{
            let array = snapshot.value as! Array<Any>
            print(array)
            var fetchedArray:Array<String> = []
            for sValue in array{
            if sValue is NSNull {
                
            }else{
                self.playersArray = []
                
                fetchedArray.append(String(describing: sValue))
                self.playersArray = fetchedArray
                for i:Int in 0 ..< self.playersArray.count{
                    if self.playerName == self.playersArray[i]{
                        
                        self.favBtn.backgroundColor = UIColor.red
                    }
                }
            }
            }
                }
        })
            
    }
    
    func setFaviouritePlayers(){
        if self.favBtn.backgroundColor != UIColor.red{
            self.databaseRef = FIRDatabase.database().reference()
            playersArray.append(playerName!)
            self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("favourites").setValue(playersArray)
            favBtn.backgroundColor = UIColor.red
        }
        else if self.favBtn.backgroundColor == UIColor.red{
            self.removeFromFavourite()
        }
        
        
        
    }
    
    
    func removeFromFavourite(){
        self.databaseRef = FIRDatabase.database().reference()
        for i:Int in 0 ..< playersArray.count{
            let playerData = playersArray[i]
            print(playerData)
            if playerName == playerData{
                
                print(i)
                self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("favourites").child(String(describing: i)).removeValue(completionBlock: {
                    (error) in
                    self.playersArray.remove(at: i)
                    print(error)
                    self.favBtn.backgroundColor = UIColor(red: 62.0/255.0, green: 174.0/255.0, blue: 230.0/255.0, alpha: 1)
                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
