//
//  Question+CoreDataProperties.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var answers: [String]
    @NSManaged public var correct_answer: Int32
    @NSManaged public var id: Int32
    @NSManaged public var question: String?

}
