//
//  Question+CoreDataClass.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/21/20.
//
//

import Foundation
import UIKit
import CoreData

@objc(Question)
public class Question: NSManagedObject {
    
    class func firstOrCreate(withId id: Int32) -> Question? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)        
        
        do {
            let question = try context.fetch(request)
            if let question = question.first {
                return question
                
            } else {
                let newQuestion = Question(entity: Question.entity(), insertInto: context)
                return newQuestion
            }
        } catch {
            return nil
        }
    }
    
    class func createFrom(json: [String: Any]) -> Question? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let id = json["id"] as? Int32,
            let q = json["question"] as? String,
            let answers = json["answers"] as? [String],
            let correctAnswer = json["correct_answer"] as? Int32{
            
            if let question = Question.firstOrCreate(withId: id) {
                question.id = id
                question.question = q
                question.answers = answers 
                question.correct_answer = correctAnswer
                
                appDelegate.saveContext()
                
                return question
                
            }
        }
        
        
        return nil
    }
}
