//
//  CategoryType.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/11/20.
//

import Foundation

enum CategoryType: String, CaseIterable{
    case SPORTS
    case SCIENCE 
    
    static func numOfTypes() -> Int {
        return CategoryType.allCases.count
    }
}
