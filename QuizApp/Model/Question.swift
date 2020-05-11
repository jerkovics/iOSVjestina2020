//
//  Question.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import Foundation

class Question{
    var id : Int?
    var question : String?
    var answers : [String]?
    var correctAnswer : Int?
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let question = jsonDict["question"] as? String,
            let answers = jsonDict["answers"] as? [String],
            let correctAnswer = jsonDict["correct_answer"] as? Int {
            
            self.id = id
            self.question = question 
            self.answers = answers
            self.correctAnswer = correctAnswer
            
        } else{
            return nil
        }
    }
}
