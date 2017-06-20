//
//  SignUpViewController.swift
//  CricNp
//
//  Created by Lizan Pradhanang on 6/3/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class SignUpViewController: UIViewController {
    
    
    var ref:FIRDatabaseReference!
    
    
    
    @IBOutlet weak var fnameTxtField: UITextField!

    @IBOutlet weak var cPassTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var lnameTxtField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var cPasswordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameView.layer.borderWidth = 1.0
        firstNameView.layer.borderColor = UIColor.white.cgColor
        firstNameView.layer.cornerRadius = 25.0
        
        lastNameView.layer.borderWidth = 1.0
        lastNameView.layer.borderColor = UIColor.white.cgColor
        lastNameView.layer.cornerRadius = 25.0
        
        emailView.layer.borderWidth = 1.0
        emailView.layer.borderColor = UIColor.white.cgColor
        emailView.layer.cornerRadius = 25.0
        
        passwordView.layer.borderWidth = 1.0
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordView.layer.cornerRadius = 25.0
        
        cPasswordView.layer.borderWidth = 1.0
        cPasswordView.layer.borderColor = UIColor.white.cgColor
        cPasswordView.layer.cornerRadius = 25.0
        signUpBtn.layer.cornerRadius = 25.0
        
        fnameTxtField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        lnameTxtField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        cPassTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        // Do any additional setup after loading the view.
        
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
    
   
    @IBAction func backBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpBtnTapped(_ sender: Any) {
        if emailTxtField.text != "" && passTxtField.text != "" {
        FIRAuth.auth()?.createUser(withEmail: emailTxtField.text!, password: passTxtField.text!, completion:{
            (user, error) in
            if self.passTxtField.text == self.cPassTxtField.text{
                if user != nil{
                    let sb = UIStoryboard(name: "Login", bundle: nil)
                    let loginVC = sb.instantiateViewController(withIdentifier: "loginVC")
                    self.present(loginVC, animated: true, completion: nil)
                    self.ref = FIRDatabase.database().reference()
                    self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("First name").setValue(self.fnameTxtField.text)
                    self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Last name").setValue(self.lnameTxtField.text)
                    self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Email").setValue(self.emailTxtField.text)
                }else{
                    let alert = UIAlertController(title: "Error", message: "Error Creating User!!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                
                let alert = UIAlertController(title: "Error", message: "Passwords donot match!!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            
          
            
        })
        
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter valid email or password!!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}
