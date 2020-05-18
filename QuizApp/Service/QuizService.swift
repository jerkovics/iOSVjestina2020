//
//  QuizService.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/10/20.
//

import Foundation
import UIKit

class QuizService {
    
    func fetchQuizzes(urlString: String, completion: @escaping (([Quiz?]) -> Void)){
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        var quizzesArray : [Quiz] = []
                        
                        //save quizzes 
                        if let dictionary = json as? [String : Any] {
                            if let quizzes = dictionary["quizzes"] as? [Any] {
                                for quiz in quizzes {
                                    if let quiz = Quiz(json: quiz) {
                                        quizzesArray.append(quiz)
                                    }
                                }
                            }
                        }
                        
                        completion(quizzesArray)
                    } catch {
                        completion([])
                        
                    }
                    
                    
                }
                
            }
            dataTask.resume()
        } else {
            completion([])
        }
    }
    
    func fetchImage(url: URL, completion: @escaping ((UIImage?) -> Void)){
        let url = url
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                completion(image)
            }
        }
    }
    

}
