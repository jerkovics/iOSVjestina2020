//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/7/20.
//

import UIKit

class QuizViewController: UIViewController, QuestionViewDelegate {
    var quiz: Quiz? = nil
    let quizService = QuizService()
    
    var numCorrectAnswers : Int = 0
    var currentQuestion : Int = 0
    var startTime : DispatchTime? = nil
    
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizButton: UIButton!
    
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
        
        startTime = .now()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        questionView.translatesAutoresizingMaskIntoConstraints = false
        questionView.isPagingEnabled = true
        questionView.isScrollEnabled = false


        DispatchQueue.main.async {
            self.correctAnswersLabel.isHidden = true
            self.timeLabel.isHidden = true
            
            self.quizTitle.text = self.quiz?.title
            
            self.quizService.fetchImage(url: self.quiz!.imageUrl) { image in
                self.quizImage.image = image
            }
            
        }
        
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            self.customView = customView
            self.questionView.isHidden = true
            self.questionView.addSubview(customView)
            self.customView?.delegate = self
        }
        // Do any additional setup after loading the view.
    }

    func setQuiz(quiz: Quiz){
        self.quiz = quiz
    }
    
    
    func onTap(isAnswerCorrect: Bool){
        if isAnswerCorrect{
            numCorrectAnswers += 1
        }

        currentQuestion += 1
        
        if(currentQuestion >= (quiz?.questionsArray.count)!){
            let endTime : DispatchTime = .now()
            let diff = Double(endTime.uptimeNanoseconds - startTime!.uptimeNanoseconds) / 1_000_000_000
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.questionView.isHidden = true
                
                self.correctAnswersLabel.isHidden = false
                self.timeLabel.isHidden = false
                self.correctAnswersLabel.text = "Correct answers: \(self.numCorrectAnswers)"
                self.timeLabel.text = "Elapsed time: \(diff) sec"
                
                
                self.quizService.sendResults(quizId: self.quiz!.id, diff: diff, numCorrectAnswers: self.numCorrectAnswers){ response in
                    
                    print(response)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: false)
                    }
                    
                }
            }
            
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            self.customView = customView
            self.questionView.isHidden = true
            self.questionView.addSubview(customView)
            customView.delegate = self
            customView.frame = CGRect(x: CGFloat(self.currentQuestion)*self.questionView.frame.size.width, y: 0, width: self.questionView.frame.size.width, height: self.questionView.frame.size.height)
            self.questionView.contentSize = CGSize(width: CGFloat(self.currentQuestion+1)*customView.bounds.width, height: self.questionView.frame.size.height)
            self.questionView.contentOffset = CGPoint(x: CGFloat(self.currentQuestion)*self.questionView.frame.size.width, y: self.questionView.contentOffset.y)

        }

        DispatchQueue.main.async {
            self.questionView.isHidden = false
            if let quiz = self.quiz{
                self.customView?.questionLabel.text = quiz.questionsArray[self.currentQuestion].question
                self.customView?.answ1.setTitle(quiz.questionsArray[self.currentQuestion].answers?[0], for: .normal)
                self.customView?.answ2.setTitle(quiz.questionsArray[self.currentQuestion].answers?[1], for: .normal)
                self.customView?.answ3.setTitle(quiz.questionsArray[self.currentQuestion].answers?[2], for: .normal)
                self.customView?.answ4.setTitle(quiz.questionsArray[self.currentQuestion].answers?[3], for: .normal)
                self.customView?.correctAnswer = quiz.questionsArray[self.currentQuestion].correctAnswer
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
