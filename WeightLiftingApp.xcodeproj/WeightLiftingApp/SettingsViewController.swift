//
//  SettingsViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 12/7/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit

class SettingsViewController: SetCategoryPickerViewController {
        //get this method of overriding from stack overflow
        override var categories: [String] {
            get{
                return ["LBs","KGs"]
            }
            set{
                
            }
        }
        
        
        override func prepare(for segue: UIStoryboardSegue,
                                 sender: Any?) {
          if segue.identifier == "PickedUnit" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
              selectedCategorySet = categories[indexPath.row]
            }
        } }
}
