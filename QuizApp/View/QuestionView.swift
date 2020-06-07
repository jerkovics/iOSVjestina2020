//
//  QuizDataView.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import UIKit

class QuestionView: UIView{
    
    var correctAnswer: Int?
    var delegate : QuestionViewDelegate? = nil
    
    @IBOutlet weak var answ4: UIButton!
    @IBOutlet weak var answ3: UIButton!
    @IBOutlet weak var answ2: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answ1: UIButton!
    
    //if correct answer is the first one and it is clicked, make it green; else, make it red
    @IBAction func an1(_ sender: Any) {
        if (correctAnswer == 0) {
            delegate?.onTap(isAnswerCorrect: true)
            answ1.backgroundColor = UIColor.green
        } else{
            delegate?.onTap(isAnswerCorrect: false)
            answ1.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func an2(_ sender: Any) {
        if (correctAnswer == 1) {
            delegate?.onTap(isAnswerCorrect: true)
            answ2.backgroundColor = UIColor.green
        } else{
            delegate?.onTap(isAnswerCorrect: false)
            answ2.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func an3(_ sender: Any) {
        if (correctAnswer == 2) {
            delegate?.onTap(isAnswerCorrect: true)
            answ3.backgroundColor = UIColor.green
        } else{
            delegate?.onTap(isAnswerCorrect: false)
            answ3.backgroundColor = UIColor.red
        }
    }
    
    
    @IBAction func an4(_ sender: Any) {
        if (correctAnswer == 3) {
            delegate?.onTap(isAnswerCorrect: true)
            answ4.backgroundColor = UIColor.green
        } else{
            delegate?.onTap(isAnswerCorrect: false)
            answ4.backgroundColor = UIColor.red
        }
    }
    
}
