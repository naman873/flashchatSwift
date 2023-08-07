//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

//    @IBOutlet var titleLabel: CLTypingLabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
//        titleLabel.text = K.appName
        
        titleLabel.text = ""

        var counter = 0.0
        let titleText = "⚡️FlashChat"
        for title in titleText {
        
            Timer.scheduledTimer(withTimeInterval: 0.1 * counter, repeats: false) { timme in
                self.titleLabel.text?.append(title)
            }
            
//            self.titleLabel.text?.append(title)
            counter = counter + 1;
        }
       
    }
    

}
