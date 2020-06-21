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
    
    
    @IBAction func getLeaderBoard(_ sender: UIButton) {
        let leaderBoardController = LeaderBoardViewController()
        leaderBoardController.setQuiz(quiz: self.quiz!)
        
        navigationController?.pushViewController(leaderBoardController, animated: true)
        
    }
    
    
    @IBAction func tapStartQuiz(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.questionView.isHidden = false
            if let firstQuiz = self.quiz{
                self.customView?.questionLabel.text = (firstQuiz.relationship?.firstObject as! Question).question
                self.customView?.answ1.setTitle((firstQuiz.relationship?.firstObject as! Question).answers![0] , for: .normal)
                self.customView?.answ2.setTitle((firstQuiz.relationship?.firstObject as! Question).answers![1] , for: .normal)
                self.customView?.answ3.setTitle((firstQuiz.relationship?.firstObject as! Question).answers![2] , for: .normal)
                self.customView?.answ4.setTitle((firstQuiz.relationship?.firstObject as! Question).answers![3] , for: .normal)
                self.customView?.correctAnswer = Int((firstQuiz.relationship?.firstObject as! Question).correct_answer)
            }
        }
        
        startTime = .now()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionView.isPagingEnabled = true
        questionView.isScrollEnabled = false
        
        
        DispatchQueue.main.async {
            self.correctAnswersLabel.isHidden = true
            self.timeLabel.isHidden = true
            
            self.quizTitle.text = self.quiz?.title
            
            self.quizService.fetchImage(url: self.quiz!.image_url!) { image in
                self.quizImage.image = image
            }
            
        }
        
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            self.customView = customView
            self.questionView.isHidden = true
            self.questionView.addSubview(customView)
            self.customView?.delegate = self
        }
    }
    
    func setQuiz(quiz: Quiz){
        self.quiz = quiz
    }
    
    
    func onTap(isAnswerCorrect: Bool){
        if isAnswerCorrect{
            numCorrectAnswers += 1
        }
        
        currentQuestion += 1
        
        if(currentQuestion >= (quiz?.relationship?.count)!){
            let endTime : DispatchTime = .now()
            let diff = Double(endTime.uptimeNanoseconds - startTime!.uptimeNanoseconds) / 1_000_000_000
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.questionView.isHidden = true
                
                self.correctAnswersLabel.isHidden = false
                self.timeLabel.isHidden = false
                self.correctAnswersLabel.text = "Correct answers: \(self.numCorrectAnswers)"
                self.timeLabel.text = "Elapsed time: \(diff) sec"
                
                
                self.quizService.sendResults(quizId: Int(self.quiz!.id), diff: diff, numCorrectAnswers: self.numCorrectAnswers){ response in
                    
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
                    self.customView?.questionLabel.text = ((quiz.relationship![self.currentQuestion] ) as! Question).question
                    self.customView?.answ1.setTitle(((quiz.relationship![self.currentQuestion]) as! Question).answers![0] , for: .normal)
                    self.customView?.answ2.setTitle(((quiz.relationship![self.currentQuestion] ) as! Question).answers![1] , for: .normal)
                    self.customView?.answ3.setTitle(((quiz.relationship![self.currentQuestion] ) as! Question).answers![2] , for: .normal)
                    self.customView?.answ4.setTitle(((quiz.relationship![self.currentQuestion] ) as! Question).answers![3] , for: .normal)
                    self.customView?.correctAnswer = Int(((quiz.relationship![self.currentQuestion]) as! Question ).correct_answer)
                }
                
                
            }
            
        }
        
    }
    
}
