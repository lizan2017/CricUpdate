//
//  FixturesViewController.swift
//  CricNp
//
//  Created by Rojan on 6/21/2560 BE.
//  Copyright © 2560 Lizan. All rights reserved.
//

import UIKit

class FixturesViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var fixturesTableVIew: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fixtures"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 37.0/255.0, blue: 75.0/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0) , NSForegroundColorAttributeName: UIColor.white]
        
        fixturesTableVIew.delegate = self
        fixturesTableVIew.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell") as! FixturesTableViewCell
        cell.teamAimageView.layer.cornerRadius = 55.0
        cell.teamBimageView.layer.cornerRadius = 55.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
