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
        guard let url = URL(string: urlString) else{ completion([]); return}
        let request = URLRequest(url: url)
            
        let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
            
            guard let data = data else { completion([]); return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                var quizzesArray : [Quiz] = []
                
                //save quizzes
                guard let dictionary = json as? [String : Any] else { completion([]); return}
                guard let quizzes = dictionary["quizzes"] as? [Any] else{ completion([]); return}
                
                for quiz in quizzes {
                    if let quiz = Quiz(json: quiz) {
                        quizzesArray.append(quiz)
                        }
                    }
            
                completion(quizzesArray)
                
            } catch {
                completion([])
                }
            
        }
        
        dataTask.resume()
        
    }
    
    func login(urlString: String, korisnickoIme: String, lozinka: String, completion: @escaping ((String?, Int?) -> Void)){
        
        guard let url = URL(string: urlString) else { completion(nil, nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(korisnickoIme)&password=\(lozinka)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

            
        let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
            guard let data = data else {completion(nil, nil); return }
                    
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
                
        }
        
        dataTask.resume()
       
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
    
    func fetchLeaderBoard(url: String, completion: @escaping (([Score?]) -> Void)){
        guard let url = URL(string: url) else{ completion([]); return}
        var request = URLRequest(url: url)
        
        let userDefaults = UserDefaults.standard
        guard let token = userDefaults.string(forKey: "token") else{ completion([]); return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
            
            guard let data = data else { completion([]); return}
            
            do {
                let result = try JSONDecoder().decode([Score].self, from: data)
                completion(result)
                
            } catch {
                completion([])
            }
            
        }
        
        dataTask.resume()
    }
    
    
    func sendResults(quizId: Int, diff: Double, numCorrectAnswers: Int, completion: @escaping ((Response?) -> Void)){
        
        let userDefaults = UserDefaults.standard
        guard let userId = userDefaults.string(forKey: "user_id") else { completion(nil); return }
        guard let token = userDefaults.string(forKey: "token") else{ completion(nil); return }
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else {  completion(nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
            
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let parameters = ["quiz_id": quizId, "user_id": userId, "time": diff, "no_of_correct": numCorrectAnswers] as [String : Any]
            
//            let postString = "quiz_id=\(quizId)&user_id=\(userId)&time=\(diff)&no_of_correct\(numCorrectAnswers)";
            
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
                print(error.localizedDescription)
        }
            
        let dataTask = URLSession.shared.dataTask(with: request){(data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                    completion(Response(rawValue: response.statusCode))
            } else {
                    completion(nil)
            }
                
        }
        
        dataTask.resume()
        
    }
}
