//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import UIKit

class InitialViewController: UIViewController {
    
    let quizService = QuizService()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var funFactField: UILabel!
    @IBOutlet weak var quizName: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    
    var customView: QuestionView?
    
    override func viewDidLoad() {
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            self.customView = customView
            self.questionView.isHidden = true
            self.questionView.addSubview(customView)
            
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        errorLabel.isHidden = true
        quizService.fetchQuizzes(urlString: "https://iosquiz.herokuapp.com/api/quizzes") { [weak self] (quizes) in
            
            if !quizes.isEmpty {
            //get questions from quizzes
                var questions : [String] = []
                
                for quiz in quizes{
                    for question in quiz!.questionsArray {
                        questions.append(question.question!)
                    }
                }
                
                print(questions)
                
                //find how many questions have word "NBA" in it
                let funFacts = questions.filter({$0.contains("NBA")})
                let numOfFunFacts = funFacts.count
                
                print(numOfFunFacts)
                
                DispatchQueue.main.async {
                    self?.funFactField.text = "Fun Facts: " + String(numOfFunFacts)
                }

                //find image of quiz and display it
                if let quiz = quizes.first as? Quiz,
                    let qService = self?.quizService {
                    qService.fetchImage(url: quiz.imageUrl) { image in
                        self?.imageView.image = image
                    }
                    DispatchQueue.main.async {
                        //find title of quiz and display it
                        self?.quizName.text = quiz.title
                        //if the category is science, background is green; else background is yellow
                        if quiz.category == CategoryType.SCIENCE{
                            self?.imageView.backgroundColor = UIColor.green
                            self?.quizName.backgroundColor = UIColor.green
                        } else{
                            self?.imageView.backgroundColor = UIColor.yellow
                            self?.quizName.backgroundColor = UIColor.yellow
                        }
                    }
                }
                
                //make questionView of 1 question with its question and answers
                DispatchQueue.main.async {
                    self?.questionView.isHidden = false
                    self?.customView?.questionLabel.text = (quizes.first as! Quiz).questionsArray.first?.question
                    self?.customView?.answ1.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[0], for: .normal)
                    self?.customView?.answ2.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[1], for: .normal)
                    self?.customView?.answ3.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[2], for: .normal)
                    self?.customView?.answ4.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[3], for: .normal)
                    self?.customView?.correctAnswer = (quizes.first as! Quiz).questionsArray.first?.correctAnswer
                }
            
            } else{
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                }
            }
        }
        
    }
    
}
