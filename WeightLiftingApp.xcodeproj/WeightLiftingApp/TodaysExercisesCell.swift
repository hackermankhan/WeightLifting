//
//  TodaysExercisesCell.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/24/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit

class TodaysExercisesCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sets_reps_label: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var muscles: UILabel!
    var downloadTask: URLSessionDownloadTask?
    var unit = "LBS"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255,
            green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public Methods
    func configure(for result: Exercise, myUnit x: String){
        nameLabel.text = result.name
        sets_reps_label.text = "Intensity: \(result.sets) x \(result.reps)"
        if x == "LBs"{
            weight.text = "Weight: \(result.weightLBs) \(x)"
        }
        else{
            weight.text = "Weight: \(result.weightKGs) \(x)"
        }
        artwork.image = UIImage(named: "Placeholder")
        muscles.text = extractString(exercise: result, type: "Muscles")
        if let smallURL = URL(string: result.image) {
          downloadTask = artwork.loadImage(url: smallURL)
        }
    }

}
