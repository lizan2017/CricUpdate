//
//  ViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 5/31/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    var emailID : [Email] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        let leftbutton = UIBarButtonItem(image: UIImage(named: "h6"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftbutton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
    
        if self.revealViewController() != nil{
            leftbutton.target = self.revealViewController()
            leftbutton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 300.0
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

    func fetchData(){
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
    
    


}

