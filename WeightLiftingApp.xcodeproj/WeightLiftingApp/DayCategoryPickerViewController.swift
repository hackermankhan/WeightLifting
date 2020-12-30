//
//  DayCategoryPickerViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/23/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit
class DayCategoryPickerViewController: SetCategoryPickerViewController{
    
    //get this method of overriding from stack overflow
    override var categories: [String] {
        get{
            return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        }
        set{
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "PickedDay" {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
          selectedCategorySet = categories[indexPath.row]
        }
    } }
}
