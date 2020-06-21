//
//  Quiz+CoreDataClass.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/21/20.
//
//

import Foundation
import UIKit
import CoreData

@objc(Quiz)
public class Quiz: NSManagedObject {
    
    class func firstOrCreate(withId id: Int32) -> Quiz? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let quizzes = try context.fetch(request)
            if let quiz = quizzes.first {
                return quiz
            } else {
                let newQuiz = Quiz(entity: Quiz.entity(), insertInto: context)
                return newQuiz
            }
        } catch {
            print("error")
            return nil
        }
    }
    
    
    class func createFrom(json: [String: Any]) -> Quiz? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let id = json["id"] as? Int32,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let category = json["category"] as? String,
            let level = json["level"] as? Int32,
            let image = json["image"] as? String,
            let imageUrl = URL(string: image),
            
            //save questions
            let questions = json["questions"] as? [Any] {
            var questionsArray : [Question] = []
            
            for data in questions{
                if let question = Question.createFrom(json: data as! [String : Any]) {
                    questionsArray.append(question)
                }
            }
            
            print(questionsArray.count)
            
            
            if let quiz = Quiz.firstOrCreate(withId: id) {
                quiz.id = id
                quiz.title = title
                quiz.quiz_description = description
                quiz.category = CategoryType(rawValue: category)!.rawValue
                quiz.level = level
                quiz.image_url = imageUrl
                
                for question in questionsArray{
                    quiz.addToRelationship(question)
                }
                
                appDelegate.saveContext()
                
                return quiz
            }
            
        }
        return nil
    }
}
