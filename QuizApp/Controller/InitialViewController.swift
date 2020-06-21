//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import UIKit
import Reachability

class InitialViewController: UIViewController,  UITableViewDataSource,  UITableViewDelegate {
    
    let quizService = QuizService()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var funFactField: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var quizTableView: UITableView!
    
    var customView: QuestionView?
    
    let numOfTypes = CategoryType.numOfTypes()
    var quizzes: [Quiz] = []
    
    var refreshControl = UIRefreshControl()
    var reachability = try? Reachability()
    
    @IBAction func tapLogout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: false, completion: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do{
            quizzes = try context.fetch(Quiz.fetchRequest())
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        reachability?.whenUnreachable = {_ in
            self.errorLabel.isHidden = false
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        quizTableView.addSubview(refreshControl)
        
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        quizTableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCell")
        
    }
    
    @objc func refresh(){
        loadQuizzes()
    }
    
    
    func loadQuizzes(){
        self.errorLabel.isHidden = true
        self.quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizes) in
            
            if !quizes.isEmpty {
                DispatchQueue.main.async {
                    print(quizes)
                    self?.setQuizzes(quizzes: quizes as! [Quiz])
                    self?.quizTableView.reloadData()
                }
                
                //get questions from quizzes
                var questions : [String] = []
                
                for quiz in quizes{
                    for question in quiz!.relationship! {
                        questions.append((question as! Question).question!)
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
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
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
            cell?.quizLevel.text = String(repeating: "*", count: Int(quiz.level))
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
    
}
