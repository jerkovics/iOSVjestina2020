//////
//////  Quiz.swift
//////  QuizApp
//////
//////  Created by Sanja Jerkovic on 5/10/20.
//////
import Foundation
import CoreData
import UIKit

@objc(Quiz)
public class Quiz: NSManagedObject {
    
    class func firstOrCreate(withId id: Int32) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        let p = NSPredicate(format: "id = %d", id)
        
        request.predicate = p
//        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let reviews = try context.fetch(request)
            if let review = reviews.first {
                return review
            } else {
                let newReview = Quiz(context: context)
                return newReview
            }
        } catch {
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
                quiz.questions = questionsArray as [NSManagedObject]
                
                do {
                    let context = DataController.shared.persistentContainer.viewContext
                    try context.save()
                    return quiz
                } catch {
                    print("Failed saving")
                }
            }
            
        }
        return nil
    }
}

//
//import Foundation
//
//class Quiz{
//
//    let id : Int
//    let title : String
//    let description: String
//    let imageUrl : URL
//    let category: CategoryType
//    let level: Int
//    let questionsArray: [Question]
//
//    init?(json: Any) {
//        if let jsonDict = json as? [String: Any],
//            let id = jsonDict["id"] as? Int,
//            let title = jsonDict["title"] as? String,
//            let description = jsonDict["description"] as? String,
//            let category = jsonDict["category"] as? String,
//            let level = jsonDict["level"] as? Int,
//            let image = jsonDict["image"] as? String,
//            let imageUrl = URL(string: image),
//
//            //save questions
//            let questions = jsonDict["questions"] as? [Any] {
//                var questionsArray : [Question] = []
//
//                for data in questions{
//                    if let question = Question(json: data) {
//                        questionsArray.append(question)
//                    }
//                }
//
//
//                self.id = id
//                self.title = title
//                self.description = description
//                self.category = CategoryType(rawValue: category)!
//                self.level = level
//                self.imageUrl = imageUrl
//                self.questionsArray = questionsArray
////            for q in questionsArray{
////                print(q.question)
////            }
//
//        } else{
//            return nil
//        }
//
//    }
//
//}
//
