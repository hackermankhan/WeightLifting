//
//  BreakDownCell.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 12/9/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit
import CoreData

class BreakDownCell: UITableViewCell {
    
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var breakDownLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func muscleCodeToString(_ codes:[Int]) -> String{
        var all_muscles = ""
        for muscle in codes{
            switch muscle{
            case 2:
                all_muscles += "Anterior deltoid, "
            case 1:
                all_muscles += "Bicep brachii, "
            case 11:
                all_muscles += "Biceps femoris, "
            case 13:
                all_muscles += "Brachialis, "
            case 7:
                all_muscles += "Gastrocnemius, "
            case 8:
                all_muscles += "Gluteus maximus, "
            case 12:
                all_muscles += "Latissimus dorsi, "
            case 14:
                all_muscles += "Obliquus externus abdominis, "
            case 4:
                all_muscles += "Pectoralis major, "
            case 10:
                all_muscles += "Quadriceps femoris, "
            case 6:
                all_muscles += "Rectus abdominus, "
            case 3:
                all_muscles += "Serratus anterior, "
            case 15:
                all_muscles += "Soleus, "
            case 9:
                all_muscles += "Trapezius, "
            case 5:
                all_muscles += "Triceps brachii, "
            default:
                return "No Data at this time"
            }
        }
        return String(all_muscles.dropLast(2))
    }
    
    //MARK:- Public Methods
    func configure(for result: [ExercizeCD]){
        //var all_muscles_string: String = "Muscles:"
        if result.count > 0{
            var muscleDict = [Int: Int]()
            var all_muscles_int = [Int]()
            for exercises in result{
                for muscle in exercises.muscles{
                    if !all_muscles_int.contains(muscle){
                        all_muscles_int.append(muscle)
                    }
                    if muscleDict[muscle] != nil{
                        muscleDict[muscle]! += 1
                    }
                    else{
                        muscleDict[muscle] = 1
                    }
                }
                for muscle in exercises.muscles_secondary{
                    if !all_muscles_int.contains(muscle){
                        all_muscles_int.append(muscle)
                    }
                    if muscleDict[muscle] != nil{
                        muscleDict[muscle]! += 1
                    }
                    else{
                        muscleDict[muscle] = 1
                    }
                }
            }
            
            let sortedKeys = Array(muscleDict.keys).sorted(by: {muscleDict[$0]! > muscleDict[$1]!})
            //print(muscleDict)
            //print(sortedKeys)
            //calculate total amount of items
            var total = 0
            for muscle in all_muscles_int{
                total = total + muscleDict[muscle]!
            }
            var counter = 0
            var breakDownString = ""
            //get top 2 most worked out
            for key in sortedKeys{
                if(counter < 3){
                    let amount = muscleDict[Int(sortedKeys[counter])]
                    //print(amount!, total)
                    let ratio: Double = Double(amount!)/Double(total)
                    breakDownString += "\(muscleCodeToString([Int(sortedKeys[counter])])) (\(Int(ratio*100)))%, "
                    counter += 1
                }
            }
            breakDownString = String(breakDownString.dropLast(2))
            breakDownLabel.text = "Most Dominant Muscles: \(breakDownString)."
            musclesLabel.text = "Muscles: \(muscleCodeToString(all_muscles_int))"
        }
    }
}
