//
//  ScoreTableViewCell.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 6/18/20.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
