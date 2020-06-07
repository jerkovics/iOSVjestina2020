//
//  Response.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/7/20.
//

import Foundation

enum Response: Int{
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case BAD_REQUEST = 400
    case OK = 200
}
