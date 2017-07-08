//
//  NewsViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 7/8/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
import  SDWebImage

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    var newsArray:Array<[String:Any]> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let leftbutton = UIBarButtonItem(image: UIImage(named: "h6"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftbutton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if self.revealViewController() != nil{
            leftbutton.target = self.revealViewController()
            leftbutton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 300.0
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func fetchNews(){
        let dataRef = FIRDatabase.database().reference().child("News")
        dataRef.observe(.value, with: {
            (snapshot) in
            let result = snapshot.value as! [[String:Any]]
            for i:Int in 0 ..< result.count{
                let newsDic = result[i]
                self.newsArray.append(newsDic)
                self.newsTableView.reloadData()
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsTableViewCell
        let newsDict = newsArray[indexPath.row]
        let url = URL(string: newsDict["ImageUrl"] as! String)
        cell.newsDateLabel.text = newsDict["Date"] as? String
        cell.newsTimeLabel.text = newsDict["Time"] as? String
        cell.newsImageView.sd_setImage(with: url)
        cell.newsTitle.text = newsDict["Title"] as? String
        return cell
    }
}
