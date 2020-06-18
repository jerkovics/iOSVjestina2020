//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/21/20.
//

import UIKit

class InitialViewController: UIViewController,  UITableViewDataSource,  UITableViewDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var funFactField: UILabel!
    @IBOutlet weak var quizTableView: UITableView!
    
    let quizService = QuizService()
    let numOfTypes = CategoryType.numOfTypes()
    var quizzes: [Quiz] = []
    var refreshControl = UIRefreshControl()
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.quizTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        quizTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCell")
        
//        quizService.fetchQuizzesFromDB(){ (quizzes) in
//            if let quizzes = quizzes{
//                self.quizzes = quizzes
//            }
//        }

        // Do any additional setup after loading the view.
    }

    @IBAction func tapLogout(_ : UIButton) {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = LoginViewController()
    }
    
    
    @IBAction func tapDohvati(_ : UIButton) {
        errorLabel.isHidden = true
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizes) in
            
            if !quizes.isEmpty {
                DispatchQueue.main.async {
                    //                    print(quizes)
                    self?.setQuizzes(quizzes: quizes as! [Quiz])
                    self?.quizTableView.reloadData()
                }
                
                //get questions from quizzes
                var questions : [String] = []
                
                for quiz in quizes{
                    for question in quiz!.questions {
                        questions.append((question as! Question).question!)
                    }
                }
                
                
                
                let funFacts = questions.filter({$0.contains("NBA")})
                let numOfFunFacts = funFacts.count
                
                //                print(numOfFunFacts)
                
                DispatchQueue.main.async {
                    self?.funFactField.text = "Fun Facts: " + String(numOfFunFacts)
                }
                
                
                
            } else{
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfTypes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.filter{(quiz: Quiz) -> Bool in
            quiz.category == CategoryType.allCases[section].rawValue}.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as? QuizTableViewCell
        
        let quiz = quizzes.filter{(quiz: Quiz) -> Bool in
            quiz.category == CategoryType.allCases[indexPath.section].rawValue}[indexPath.row]
        
        
        quizService.fetchImage(url: quiz.image_url!) { image in
            cell?.quizImage.image = image
        }
        
        DispatchQueue.main.async {
            cell?.quizTitle.text = quiz.title
            cell?.quizLevel.text = String(quiz.level)
            cell?.quizDescription.text = quiz.quiz_description
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "\(CategoryType.allCases[section])"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let quiz = quizzes.filter{(quiz: Quiz) -> Bool in
            quiz.category == CategoryType.allCases[indexPath.section].rawValue}[indexPath.row]
        
        let quizController = QuizViewController()
        quizController.setQuiz(quiz: quiz)
        
        navigationController?.pushViewController(quizController, animated: true)
        
    }
    
    func setQuizzes(quizzes: [Quiz]) {
        self.quizzes = quizzes
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
