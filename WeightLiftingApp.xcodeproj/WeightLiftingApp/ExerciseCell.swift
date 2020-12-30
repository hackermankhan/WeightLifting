//
//  ExerciseCell.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/12/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sets_reps_label: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    var unit = "LBS"

    override func awakeFromNib() {
      super.awakeFromNib()
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
    func configure(for result: Exercise){
        nameLabel.text = result.name
        sets_reps_label.text = "\(result.sets) x \(result.reps)"
        weight.text = "Weight: \(result.weightLBs) \(unit)"
        artwork.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.image) {
          downloadTask = artwork.loadImage(url: smallURL)
        }
    }
}
