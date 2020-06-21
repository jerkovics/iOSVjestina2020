//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var quizTable: UITableView!
    
    let quizService = QuizService()
    var quizzes : [Quiz] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as? QuizTableViewCell
        
        let quiz = quizzes[indexPath.row]
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let quiz = quizzes[indexPath.row]
        
        let quizController = QuizViewController()
        quizController.setQuiz(quiz: quiz)
        
        navigationController?.pushViewController(quizController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quizTable.delegate = self
        self.quizTable.dataSource = self
        
        quizTable.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCell")
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        quizService.retrieveQuizzes(searched: String(self.searchField!.text!)) { [weak self] (quizzes) in
            DispatchQueue.main.async {
                self?.quizzes = quizzes as! [Quiz]
                self?.quizTable.isHidden = false
                self!.quizTable.reloadData()
            }
        }
    }
}
