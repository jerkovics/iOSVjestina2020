//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/5/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var quizAppLabel: UILabel!
    @IBOutlet weak var korisnickoIme: UITextField!
    @IBOutlet weak var lozinka: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var quizService = QuizService()
    let initialController = UINavigationController(rootViewController: InitialViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizAppLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        quizAppLabel.alpha = 0
        korisnickoIme.alpha = 0
        lozinka.alpha = 0
        loginButton.alpha = 0
        
        korisnickoIme.transform = CGAffineTransform(translationX: -korisnickoIme.frame.origin.x - korisnickoIme.frame.width, y: 0)

        lozinka.transform = CGAffineTransform(translationX: -lozinka.frame.origin.x - lozinka.frame.width, y: 0)
        
        loginButton.transform = CGAffineTransform(translationX: -loginButton.frame.origin.x - loginButton.frame.width, y: 0)
        
        animateLoginIn()
        // Do any additional setup after loading the view.
    }
    
    func animateLoginIn(){
        UIView.animate(withDuration: 1.35, delay: 0,  options: [.curveEaseOut], animations: {
            self.quizAppLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self.quizAppLabel.alpha = 1
            self.korisnickoIme.alpha = 1
            self.lozinka.alpha = 1
            self.loginButton.alpha = 1
            

        })
        
        UIView.animate(withDuration: 1.0, delay: 0,  options: [.curveEaseOut], animations: {
            self.korisnickoIme.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
            self.lozinka.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.4, options: [.curveEaseOut], animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func animateLoginOut(completion: @escaping (() -> Void)){
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
            self.quizAppLabel.transform = CGAffineTransform(translationX: 0, y: -self.quizAppLabel.frame.origin.y - self.quizAppLabel.frame.height)
            
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
            self.korisnickoIme.transform = CGAffineTransform(translationX: 0, y: -self.korisnickoIme.frame.origin.y - self.korisnickoIme.frame.height)

        })
        
        UIView.animate(withDuration: 1.0, delay: 0.4, options: [.curveEaseOut], animations: {
            self.lozinka.transform = CGAffineTransform(translationX: 0, y: -self.lozinka.frame.origin.y - self.lozinka.frame.height)
            
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.8, options: [.curveEaseOut], animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: -self.loginButton.frame.origin.y - self.loginButton.frame.height)
            
        }){ _ in
            completion()
        }
    }
    
    @IBAction func tapLogin(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
        }
        guard let korisnickoIme = self.korisnickoIme.text else { return }
        guard let lozinka = self.lozinka.text else { return }
        
        quizService.login(urlString: "https://iosquiz.herokuapp.com/api/session", korisnickoIme: korisnickoIme , lozinka: lozinka){ (token, id) in
            
            if token != nil && id != nil {
                let userDefaults = UserDefaults.standard
                userDefaults.set(korisnickoIme, forKey:  "username")
                userDefaults.set(token, forKey: "token")
                userDefaults.set(id, forKey: "user_id")
                
                
                DispatchQueue.main.async {
                    self.animateLoginOut(){
                        let first: UIViewController = InitialViewController()
                        let navigationController = UINavigationController(rootViewController: first)
                        navigationController.tabBarItem = UITabBarItem(title: "Quizzes", image: nil, tag: 0)
                        
                        let settingsController = SettingsViewController()
                        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: nil,  tag: 0)
                        
                        let searchController = UINavigationController(rootViewController: SearchViewController())
                        searchController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
                        
                        let tabController = UITabBarController()
                        tabController.viewControllers = [navigationController, settingsController, searchController]
                        
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = tabController
                    }
                }

                    
                        
                        //                    self.navigationController?.popToViewController(self.initialController, animated: false)
                
            } else{
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                }
            }
            
        }
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
