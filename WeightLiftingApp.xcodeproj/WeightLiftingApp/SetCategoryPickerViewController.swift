//
//  SetCategoryPickerViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/16/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//



// code from chapter 30 of the text book

import UIKit
class SetCategoryPickerViewController: UITableViewController {
  var selectedCategorySet = ""
    var firstItem = "None"
  var categories = ["1","2","3","4","5"]
    //the exercise that we pick
    var thisExercise = Exercise()


    
    var selectedIndexPath = IndexPath()
    override func viewDidLoad() {
      super.viewDidLoad()
        //code from stack overflow - get rid of  empty cells
        tableView.tableFooterView = UIView()
      for i in 0..<categories.count {
        if categories[i] == selectedCategorySet {
          selectedIndexPath = IndexPath(row: i, section: 0)
    break
    } }
    }
    
    
    //MARK:-Navigation
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "PickedSets" {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
          selectedCategorySet = categories[indexPath.row]
        }
    } }
    
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
          numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) ->
                 UITableViewCell {
      let cell = tableView.dequeueReusableCell(
                           withIdentifier: "Cell",
                                      for: indexPath)
      let categoryName = categories[indexPath.row]
      cell.textLabel!.text = categoryName
      if categoryName == selectedCategorySet {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
      }
    return cell }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
              newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(
                             at: selectedIndexPath) {
              oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
        
            }
    }
}
