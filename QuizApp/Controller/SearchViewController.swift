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
        var cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as? QuizTableViewCell
        
        let quiz = quizzes[indexPath.row]
        
        
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

        // Do any additional setup after loading the view.
    }

    @IBAction func tapSearch(_ sender: Any) {
        quizService.fetchQuizzes(urlString:"https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizzes) in
            DispatchQueue.main.async {
                self?.quizzes.removeAll()
                if !quizzes.isEmpty {
                    for quiz in quizzes{
                        if ((quiz?.title.lowercased().contains(String(self!.searchField!.text!.lowercased())))!) || ((quiz?.description.lowercased().contains(String(self!.searchField!.text!.lowercased())))!){
                            self!.quizzes.append(quiz!)
                        }
                    }
                    

                        self?.quizTable.isHidden = false
                        self!.quizTable.reloadData()
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
