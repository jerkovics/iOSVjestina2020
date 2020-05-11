//
//  QuizDataView.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import UIKit

class QuestionView: UIView{
    
    var correctAnswer: Int?
    
    @IBOutlet weak var answ4: UIButton!
    @IBOutlet weak var answ3: UIButton!
    @IBOutlet weak var answ2: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answ1: UIButton!
    
    //if correct answer is the first one and it is clicked, make it green; else, make it red
    @IBAction func an1(_ sender: Any) {
        if (correctAnswer == 0) {
            answ1.backgroundColor = UIColor.green
        } else{
            answ1.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func an2(_ sender: Any) {
        if (correctAnswer == 1) {
            answ1.backgroundColor = UIColor.green
        } else{
            answ1.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func an3(_ sender: Any) {
        if (correctAnswer == 2) {
            answ1.backgroundColor = UIColor.green
        } else{
            answ1.backgroundColor = UIColor.red
        }
    }
    
    
    @IBAction func an4(_ sender: Any) {
        if (correctAnswer == 3) {
            answ1.backgroundColor = UIColor.green
        } else{
            answ1.backgroundColor = UIColor.red
        }
    }
    
}
