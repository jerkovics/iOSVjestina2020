//
//  Quiz.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import Foundation

class Quiz{
    
    let id : Int
    let title : String
    let imageUrl : URL
    let category: CategoryType
    let questionsArray: [Question]
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let title = jsonDict["title"] as? String,
            let category = jsonDict["category"] as? String,
            let image = jsonDict["image"] as? String,
            let imageUrl = URL(string: image),
            
            //save questions
            let questions = jsonDict["questions"] as? [Any] {
                var questionsArray : [Question] = []
                for data in questions{
                    if let question = Question(json: data) {
                        questionsArray.append(question)
                    }
                }
        
        
            self.id = id
            self.title = title
            self.category = CategoryType(rawValue: category)!  
            self.imageUrl = imageUrl
            self.questionsArray = questionsArray
            for q in questionsArray{
                print(q.question)
            }
            
        } else{
            return nil
        }
       
    }
    
}

