//
//  ViewController.swift
//  ParseChat
//
//  Created by Taylor McLaughlin on 10/2/18.
//  Copyright © 2018 Taylor McLaughlin. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func onSignUp(_ sender: Any) {
        
        registerUser()
        
    }
    @IBAction func onLogin(_ sender: Any) {
        
        loginUser()
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() {
        
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        if newUser.username!.isEmpty || newUser.password!.isEmpty {
            let alertController = UIAlertController(title: "Sign up error", message: "Username or passowrd is empty", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
        }
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                })
                
                alertController.addAction(cancelAction)
                
                
            } else {
                
                print("User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            }
        }
        
    }
    
    func loginUser() {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
    }

}

