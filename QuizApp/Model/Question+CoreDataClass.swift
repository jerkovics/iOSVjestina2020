//
//  Question+CoreDataClass.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//
//

import Foundation
import UIKit
import CoreData

@objc(Question)
public class Question: NSManagedObject {
    
    required convenience init?(coder aDecoder: NSCoder) {
        //add code here
        self.init()
    }
    
    class func firstOrCreate(withId id: Int32) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
//        request.returnsObjectsAsFaults = false
        
        
        do {
            let question = try context.fetch(request)
            if let question = question.first {
                return question

            } else {
                let newQuestion = Question(context: context)
                return newQuestion
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
                    print("Failed saving question")
                }
            }
        }
        
        
        return nil
    }
    
}
