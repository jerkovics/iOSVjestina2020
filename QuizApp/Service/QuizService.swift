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
    
    func login(urlString: String, korisnickoIme: String, lozinka: String, completion: @escaping ((String?, Int?) -> Void)){
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
                // HTTP Request Parameters which will be sent in HTTP Request Body
            let postString = "username=\(korisnickoIme)&password=\(lozinka)";
            // Set HTTP Request Body
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//            } catch let error {
//                print(error.localizedDescription)
//                completion(nil, nil)
//            }
            
            let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        
                            if let token = json?["token"] as? String,
                                let id = json?["user_id"] as? Int{
                                completion(token, id)
                            } else {
                                completion(nil, nil)
                            }
                        
                        
                    } catch {
                        completion(nil, nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
            }
            dataTask.resume()
        } else {
            completion(nil, nil)
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
