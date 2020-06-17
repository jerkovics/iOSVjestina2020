//
//  LeaderBoardViewController.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/12/20.
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
        guard let id = quiz?.id else { return }
        leaderBoardTableVIew.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
        print("https://iosquiz.herokuapp.com/api/score?quiz_id=\(id)")
        quizService.fetchLeaderBoard(url: "https://iosquiz.herokuapp.com/api/score?quiz_id=\(id)"){ (scores) in
            
//            print(scores)
            self.scores = Array(scores.filter{ (score) in
                score?.score != nil}.prefix(20)) as! Array<Score>
            
            DispatchQueue.main.async {
                self.leaderBoardTableVIew.reloadData()
            }
//            print(self.scores)
        }
        // Do any additional setup after loading the view.
    }

    func setQuiz(quiz: Quiz){
        self.quiz = quiz
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(scores.count)
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as? ScoreTableViewCell
        
        let score = scores[indexPath.row]
        
        cell?.username.text = "Username: " + score.username
        cell?.score.text = "Score: \(String(describing: score.score!))"
        
        return cell!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
