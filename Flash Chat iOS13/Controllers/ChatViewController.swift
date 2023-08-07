//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var db = Firestore.firestore()
    
    var messages: [Message] = [

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        navigationItem.hidesBackButton = true
        navigationItem.title = K.appName
        
        loadMessage()
    }
    
    
    func loadMessage(){
    
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() { (querySnapshot, err) in
           
            self.messages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var data = document.data()
                    
                    if let messageSender =  data[K.FStore.senderField] as? String , let messageBody = data[K.FStore.bodyField] as? String {
                        let message = Message(sender: messageSender, body: messageBody)
                        self.messages.append(message)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            var indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                  
                }
            }
        }
        
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let email = Auth.auth().currentUser?.email , let message = messageTextfield.text {
            
            
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: String(email) , K.FStore.bodyField: String(message),
                                                                            K.FStore.dateField: Date().timeIntervalSince1970
                                                                           
                                                                           ]) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
            
            
        }
        
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        navigationController?.popToRootViewController(animated: true)
        
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,for: indexPath) as! MessageCell
        cell.label?.text = message.body
        
        ///This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor =   UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        ///This is a message from the another user
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor =   UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}


//extension ChatViewController: UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//
//}
