//
//  Quiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/21/20.
//
//

import Foundation
import CoreData


extension Quiz {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var category: String?
    @NSManaged public var image_url: URL?
    @NSManaged public var level: Int32
    @NSManaged public var quiz_description: String?
    @NSManaged public var title: String?
    @NSManaged public var relationship: NSOrderedSet?
    
}

// MARK: Generated accessors for relationship
extension Quiz {
    
    @objc(insertObject:inRelationshipAtIndex:)
    @NSManaged public func insertIntoRelationship(_ value: Question, at idx: Int)
    
    @objc(removeObjectFromRelationshipAtIndex:)
    @NSManaged public func removeFromRelationship(at idx: Int)
    
    @objc(insertRelationship:atIndexes:)
    @NSManaged public func insertIntoRelationship(_ values: [Question], at indexes: NSIndexSet)
    
    @objc(removeRelationshipAtIndexes:)
    @NSManaged public func removeFromRelationship(at indexes: NSIndexSet)
    
    @objc(replaceObjectInRelationshipAtIndex:withObject:)
    @NSManaged public func replaceRelationship(at idx: Int, with value: Question)
    
    @objc(replaceRelationshipAtIndexes:withRelationship:)
    @NSManaged public func replaceRelationship(at indexes: NSIndexSet, with values: [Question])
    
    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Question)
    
    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Question)
    
    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSOrderedSet)
    
    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSOrderedSet)
    
}
