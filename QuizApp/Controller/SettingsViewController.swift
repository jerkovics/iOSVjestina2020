//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/12/20.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        guard let username = userDefaults.string(forKey: "username") else{ return }
        
        self.username.text = username
        // Do any additional setup after loading the view.
    }

    @IBAction func tapLogout(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = LoginViewController()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
