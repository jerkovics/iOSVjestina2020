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
    @IBOutlet var questionViewContainer: QuestionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet var questionView: UIView!
    
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
                if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
                    self?.questionView.addSubview(customView)
                    customView.questionLabel.text = (quizes.first as! Quiz).questionsArray.first?.question
                    customView.answ1.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[0], for: .normal)
                    customView.answ2.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[1], for: .normal)
                    customView.answ3.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[2], for: .normal)
                    customView.answ4.setTitle((quizes.first as! Quiz).questionsArray.first?.answers?[3], for: .normal)
                    customView.correctAnswer = (quizes.first as! Quiz).questionsArray.first?.correctAnswer
                    }
                }
            
            } else{
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                }
            }
        }
        
    }
    
}
