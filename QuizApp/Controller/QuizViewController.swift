//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/7/20.
//

import UIKit

class QuizViewController: UIViewController {
    var quiz: Quiz? = nil
    let quizService = QuizService()
    
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizButton: UIButton!
    
    @IBOutlet weak var questionView: UIScrollView!
    var customView: QuestionView?

    
    @IBAction func tapStartQuiz(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.questionView.isHidden = false
            if let firstQuiz = self.quiz{
                self.customView?.questionLabel.text = firstQuiz.questionsArray.first?.question
                self.customView?.answ1.setTitle(firstQuiz.questionsArray.first?.answers?[0], for: .normal)
                self.customView?.answ2.setTitle(firstQuiz.questionsArray.first?.answers?[1], for: .normal)
                self.customView?.answ3.setTitle(firstQuiz.questionsArray.first?.answers?[2], for: .normal)
                self.customView?.answ4.setTitle(firstQuiz.questionsArray.first?.answers?[3], for: .normal)
                self.customView?.correctAnswer = firstQuiz.questionsArray.first?.correctAnswer
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.quizTitle.text = self.quiz?.title
            
            self.quizService.fetchImage(url: self.quiz!.imageUrl) { image in
                self.quizImage.image = image
            }
            
        }
        
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            self.customView = customView
            self.questionView.isHidden = true
            self.questionView.addSubview(customView)
            
        }
        // Do any additional setup after loading the view.
    }

    func setQuiz(quiz: Quiz){
        self.quiz = quiz
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
