//
//  PlayerProfileViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {
    @IBOutlet weak var playerImageView: UIImageView!

    @IBOutlet weak var playerCharacterLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player's Profile"
        // Do any additional setup after loading the view.
        
        playerImageView.layer.cornerRadius = 75.0
        
        
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
