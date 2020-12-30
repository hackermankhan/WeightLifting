//
//  ExercisesCell.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/22/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit

class ExercisesCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sets_reps_label: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    var weight_unit = UserDefaults.standard.value(forKey: "Unit")
    
    
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
        sets_reps_label.text = "\(result.sets) x \(result.reps)"
        if x == "LBs"{
            weight.text = "Weight: \(result.weightLBs) \(x)"
        }
        else{
            weight.text = "Weight: \(result.weightKGs) \(x)"
        }
        dayLabel.text = "\(result.day)"
        artwork.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.image) {
          downloadTask = artwork.loadImage(url: smallURL)
        }
    }

}
