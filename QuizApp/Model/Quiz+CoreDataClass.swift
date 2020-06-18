//
//  Quiz+CoreDataClass.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//
//

import Foundation
import UIKit
import CoreData

@objc(Quiz)
public class Quiz: NSManagedObject {
    
    required convenience init?(coder aDecoder: NSCoder) {
        //add code here
        self.init()
    }
    
    class func firstOrCreate(withId id: Int32) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let quizzes = try context.fetch(request)
            print(quizzes)
            if let quiz = quizzes.first {
                print("if let")
                return quiz
            } else {
                let newQuiz = Quiz(context: context)
                return newQuiz
            }
        } catch {
            print("error")
            return nil
        }
    }
    
    
    class func createFrom(json: [String: Any]) -> Quiz? {
        //        print(json)
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
                quiz.questions = questionsArray as [NSObject]
                
                print(DataController.shared.persistentContainer.viewContext)
                
                do {
                    let context = DataController.shared.persistentContainer.viewContext
                    try context.save()
                    return quiz
                } catch {
                    print("Failed saving quiz")
                }
            }
            
        }
        return nil
    }
    
}
