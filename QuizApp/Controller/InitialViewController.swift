//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import UIKit

class InitialViewController: UIViewController,  UITableViewDataSource,  UITableViewDelegate {
    
    let quizService = QuizService()
//    let quizTableViewController = QuizTableViewController()
    
    @IBOutlet weak var funFactField: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var quizTableView: UITableView!
    
    var customView: QuestionView?
    
    let numOfTypes = CategoryType.numOfTypes()
    var quizzes: [Quiz] = []
    
    
    @IBAction func tapLogout(_ sender: UIButton) {
        self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: false, completion: {})
    }
    
    override func viewDidLoad() {
        
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        quizTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCell")

    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        errorLabel.isHidden = true
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizes) in
            
            if !quizes.isEmpty {
                DispatchQueue.main.async {
                    print(quizes)
                    self?.setQuizzes(quizzes: quizes as! [Quiz])
                    self?.quizTableView.reloadData()
                }
                
            //get questions from quizzes
                var questions : [String] = []
                
                for quiz in quizes{
                    for question in quiz!.questionsArray {
                        questions.append(question.question!)
                    }
                }
            
                
                
                let funFacts = questions.filter({$0.contains("NBA")})
                let numOfFunFacts = funFacts.count
                
                print(numOfFunFacts)
                
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
            quiz.category == CategoryType.allCases[section]}.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as? QuizTableViewCell
        
        let quiz = quizzes.filter{(quiz: Quiz) -> Bool in
            quiz.category == CategoryType.allCases[indexPath.section]}[indexPath.row]
        
        
        quizService.fetchImage(url: quiz.imageUrl) { image in
            cell?.quizImage.image = image
        }
        
        DispatchQueue.main.async {
            cell?.quizTitle.text = quiz.title
            cell?.quizLevel.text = String(quiz.level)
            cell?.quizDescription.text = quiz.description
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
            quiz.category == CategoryType.allCases[indexPath.section]}[indexPath.row]
        
        let quizController = QuizViewController()
        quizController.setQuiz(quiz: quiz)
        
        navigationController?.pushViewController(quizController, animated: true)
        
    }
    
    func setQuizzes(quizzes: [Quiz]) {
        self.quizzes = quizzes
    }
    
}
