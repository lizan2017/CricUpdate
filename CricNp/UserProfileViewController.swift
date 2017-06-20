//
//  UserProfileViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/12/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNametxtfielf: UITextField!

    @IBOutlet weak var editUserName: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var editEmail: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    var userName:String?
    let picker = UIImagePickerController()
    
    var databaseRef:FIRDatabaseReference!
    var storageRef:FIRStorageReference!
     var emailID : [Email] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarMod()
        self.title = "User Profile"
        picker.delegate = self
        picker.allowsEditing = true
        self.userImageView.layer.borderColor = UIColor.gray.cgColor
        self.userImageView.layer.borderWidth = 2.0
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(launchPicker))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
        self.fetchUserDetails()
        self.editEmail.addTarget(self, action: #selector(editEmailData), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func navbarMod(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 53.0/255.0, blue: 102.0/255.0, alpha: 1)
        let leftbutton = UIBarButtonItem(image: UIImage(named: "h6"), style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = leftbutton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        if self.revealViewController() != nil{
            leftbutton.target = self.revealViewController()
            leftbutton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 300.0
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func fetchUserDetails(){
        self.databaseRef = FIRDatabase.database().reference()
        databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {
            (snapshot) in
            
            let userDataDic = snapshot.value as! [String:Any]
            self.userNameLabel.text = "\(userDataDic["First name"] as! String) \(userDataDic["Last name"] as! String)"
            self.userNametxtfielf.text = "\(userDataDic["First name"] as! String) \(userDataDic["Last name"] as! String)"
            self.emailTextField.text = userDataDic["Email"] as? String
            
            if userDataDic["ImageUrl"] != nil{
                let url = URL(string: userDataDic["ImageUrl"] as! String)
                self.userImageView.sd_setImage(with: url)
            }else{
                return
            }
        })
    }
    
    func launchPicker(){
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage:UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage{
           self.storageRef = FIRStorage.storage().reference()
            if let uploadImage = UIImagePNGRepresentation(selectedImage){
                self.storageRef.child("UserImages").child(userName!).child("image.png").put(uploadImage, metadata: nil, completion: {
                    (metadata, error) in
                    self.databaseRef = FIRDatabase.database().reference()
                    self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("ImageUrl").setValue(String(describing: (metadata?.downloadURL())!))
                    
                    let alert = UIAlertController(title: "Sucess", message: "Profile picture uploaded sucessfully", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                    self.userImageView.image = selectedImage
                })
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func editEmailData(){
        self.databaseRef = FIRDatabase.database().reference()
        self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Email").setValue(emailTextField.text)
        FIRAuth.auth()?.currentUser?.updateEmail(emailTextField.text!, completion: {
            (error) in
            let alert = UIAlertController(title: "Sucess", message: "Email updated sucessfully!! Please Login Again", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                try? FIRAuth.auth()?.signOut()
                self.fetchDataAndDelete()
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

