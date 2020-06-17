////
////  Question.swift
////  QuizApp
////
////  Created by Sanja Jerkovic on 5/10/20.
////
//

import CoreData
import UIKit

@objc(Question)
class Question: NSManagedObject{
    
    class func firstOrCreate(withId id: Int32) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext
        print("hej")            
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        
        
        do {
            let reviews = try context.fetch(request)
            if let review = reviews.first {
                return review
                
            } else {
                let newReview = Question(context: context)
                return newReview
            }
        } catch {
            return nil
        }
    }
    
    class func createFrom(json: [String: Any]) -> Question? {
//        print(json)
        if let id = json["id"] as? Int32,
            let q = json["question"] as? String,
            let answers = json["answers"] as? [String],
            let correctAnswer = json["correct_answer"] as? Int32{
            print("if")
            if let question = Question.firstOrCreate(withId: id) {
                question.id = id
                question.question = q
                question.answers = answers
                question.correct_answer = correctAnswer
                
                do {
                    let context = DataController.shared.persistentContainer.viewContext
                    try context.save()
                    return question
                } catch {
                    print("Failed saving")
                }
            }
        }
        
        
        return nil
    }
}

//import Foundation
//
//class Question{
//    var id : Int?
//    var question : String?
//    var answers : [String]?
//    var correctAnswer : Int?
//
//    init?(json: Any) {
//        if let jsonDict = json as? [String: Any],
//            let id = jsonDict["id"] as? Int,
//            let question = jsonDict["question"] as? String,
//            let answers = jsonDict["answers"] as? [String],
//            let correctAnswer = jsonDict["correct_answer"] as? Int {
//
//            self.id = id
//            self.question = question
//            self.answers = answers
//            self.correctAnswer = correctAnswer
//
//        } else{
//            return nil
//        }
//    }
//}
