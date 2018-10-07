//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Taylor McLaughlin on 10/3/18.
//  Copyright © 2018 Taylor McLaughlin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messgaeTextField: UITextField!
    
    var chatMessages: [PFObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chatMessage = chatMessages[indexPath.row]
        cell.messagesLabel.text = chatMessage["text"] as? String
        if let user = chatMessage["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "???"
        }
        
        return cell
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 50
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        chatTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(_ sender: Any) {
        
        let newMessage = PFObject(className: "Messages")
        newMessage["text"] = self.messgaeTextField.text ?? ""
        newMessage["user"] = PFUser.current()
        newMessage.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("The message was saved!")
                self.messgaeTextField.text = ""
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @objc func onTimer() {
        let query = PFQuery(className: "Messages")
        query.addAscendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages, error: Error?) in
            if let messages = messages {
                self.chatMessages = messages
                self.chatTableView.reloadData()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func onTap(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
}
