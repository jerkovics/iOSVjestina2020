//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/5/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var korisnickoIme: UITextField!
    @IBOutlet weak var lozinka: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    

    var quizService = QuizService()
    let initialController = InitialViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                userDefaults.set(token, forKey: "token")
                userDefaults.set(id, forKey: "user_id")
                DispatchQueue.main.async {
                    self.initialController.modalPresentationStyle = .fullScreen
                    self.present(self.initialController, animated: false, completion: {})
//                    self.navigationController?.popToViewController(self.initialController, animated: false)
                }
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
