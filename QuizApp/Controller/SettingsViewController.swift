//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        guard let username = userDefaults.string(forKey: "username") else { return }
        
        self.username.text = username
    }
    
    @IBAction func tapLogout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = LoginViewController()
        
    }
}
