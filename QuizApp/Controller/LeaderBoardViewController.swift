//
//  LeaderBoardViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//

import UIKit

class LeaderBoardViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate {
    var quiz: Quiz? = nil
    var scores : Array<Score> = [] 
    
    @IBOutlet weak var leaderBoardTableVIew: UITableView!
    let quizService = QuizService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderBoardTableVIew.delegate = self
        leaderBoardTableVIew.dataSource = self
        leaderBoardTableVIew.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
        
        guard let id = quiz?.id else { return }
        quizService.fetchLeaderBoard(url: "https://iosquiz.herokuapp.com/api/score?quiz_id=\(id)"){ (scores) in
            
            self.scores = Array(scores.filter{ (score) in
                score?.score != nil}.prefix(20)) as! Array<Score>
            
            DispatchQueue.main.async {
                self.leaderBoardTableVIew.reloadData()
            }
        }
    }
    
    func setQuiz(quiz: Quiz){
        self.quiz = quiz
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(scores.count)
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as?  ScoreTableViewCell
        
        let score = scores[indexPath.row]
        
        cell?.username.text = "Username: " + score.username
        cell?.score.text = "Score: \(String(describing: score.score!))"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
}
