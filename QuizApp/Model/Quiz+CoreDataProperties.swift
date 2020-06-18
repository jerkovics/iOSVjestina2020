//
//  Quiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//
//

import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: Int32
    @NSManaged public var image_url: URL?
    @NSManaged public var level: Int32
    @NSManaged public var questions: NSObject?
    @NSManaged public var quiz_description: String?
    @NSManaged public var title: String?

}
