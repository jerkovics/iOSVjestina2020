//
//  QuestionViewDelegate.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/7/20.
//

import Foundation

protocol QuestionViewDelegate {
    func onTap(isAnswerCorrect: Bool)
}
