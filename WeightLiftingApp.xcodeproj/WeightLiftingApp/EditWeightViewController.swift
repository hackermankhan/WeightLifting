//
//  EditWeightViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/18/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit

protocol EditWeightControllerDelegate: class {
func editHighScoreViewControllerDidCancel( _ controller:                                                        EditWeightViewController)
func editHighScoreViewController( _ controller: EditWeightViewController,
                                    didFinishEditing item: Float)
    
}


class EditWeightViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var unitLabel: UILabel!
    var weight_unit = UserDefaults.standard.value(forKey: "Unit")
    
    weak var delegate: EditWeightControllerDelegate?
    var weightItem: Float!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code from stack overflow - get rid of  empty cells
        tableView.tableFooterView = UIView()
        doneBarButton.isEnabled = false
        
        unitLabel.text = weight_unit as! String
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
    }
    
    
    //MARK:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(in: stringRange,with: string)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
    } else {
        doneBarButton.isEnabled = true
      }
    return true
    }
    
    
    // MARK:- Actions
    @IBAction func cancel() {
      //navigationController?.popViewController(animated: true)
        delegate?.editHighScoreViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
      //navigationController?.popViewController(animated: true)
        weightItem = Float(textField.text!)
        delegate?.editHighScoreViewController(self, didFinishEditing:
        weightItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
              willSelectRowAt indexPath: IndexPath)
              -> IndexPath? {
      return nil
    }

}
