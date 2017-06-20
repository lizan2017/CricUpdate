//
//  LoginViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/2/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookImg: UIImageView!
    @IBOutlet weak var googleImg: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var userEmailView: UIView!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userEmailTextFiled: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailView.layer.borderWidth = 1.0
        self.userEmailView.layer.borderColor = UIColor.white.cgColor
        self.passwordView.layer.borderColor = UIColor.white.cgColor
        self.userEmailView.layer.cornerRadius = 25.0
        self.googleView.layer.cornerRadius = 25.0
        self.facebookView.layer.cornerRadius = 25.0
        self.passwordView.layer.borderWidth = 1.0
        self.passwordView.layer.cornerRadius = 25.0
        self.loginBtn.layer.cornerRadius = 25.0
        self.signUpBtn.layer.cornerRadius = 25.0
        // Do any additional setup after loading the view.
        userEmailTextFiled.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)])
        googleImg.layer.borderColor = UIColor.white.cgColor
        googleImg.layer.borderWidth = 1.0
        googleImg.layer.cornerRadius = 12.5
        facebookImg.layer.borderColor = UIColor.white.cgColor
        facebookImg.layer.borderWidth = 1.0
        facebookImg.layer.cornerRadius = 12.5
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dissmissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
  
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        if userEmailTextFiled.text != ""  && passwordTextField.text != "" {
            FIRAuth.auth()?.signIn(withEmail: userEmailTextFiled.text!, password: passwordTextField.text!, completion: {(user,error) in
                if user != nil{
                    let sb = UIStoryboard(name: "PlayersMenu", bundle: nil)
                    let nextVc = sb.instantiateViewController(withIdentifier: "main")
                    self.present(nextVc, animated: true, completion: nil)
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appdelegate.persistentContainer.viewContext
                    let emailEntity = Email(context: context)
                    emailEntity.email = self.userEmailTextFiled.text
                    do{
                        try context.save()
                    }catch{
                        
                    }

                }else{
                    if let myError = error?.localizedDescription{
                        let alert = UIAlertController(title: nil, message: myError, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            })
        }
        
        
        
    }

    @IBAction func signUpBtnTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        let signupVC = sb.instantiateViewController(withIdentifier: "suVC")
        self.present(signupVC, animated: true, completion: nil)
        
    }
   

}
