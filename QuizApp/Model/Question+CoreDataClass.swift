////
////  Question.swift
////  QuizApp
////
////  Created by Sanja Jerkovic on 5/10/20.
////
//
import Foundation
import CoreData
import UIKit

@objc(Question)
class Question: NSManagedObject{
    
    class func firstOrCreate(withId id: Int32) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext         
        
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

        if let id = json["id"] as? Int32,
            let q = json["question"] as? String,
            let answers = json["answers"] as? [String],
            let correctAnswer = json["correct_answer"] as? Int32{

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
