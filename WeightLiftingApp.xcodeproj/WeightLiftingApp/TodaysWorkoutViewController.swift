//
//  TodaysWorkoutViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/24/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class TodaysWorkoutViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext! {
      didSet {
        NotificationCenter.default.addObserver(forName:
           Notification.Name.NSManagedObjectContextObjectsDidChange,
           object: managedObjectContext,
           queue: OperationQueue.main) { notification in
            if self.isViewLoaded{
                self.updateTodaysWorkOuts()
            }
    } }
    }
    
    var todaysWorkouts: [ExercizeCD] = []
    var allWorkouts = [ExercizeCD]()
    var totalWorkOuts = 0
    
    
    func updateTodaysWorkOuts(){
        let entity = ExercizeCD.entity()
        let fetchRequest = NSFetchRequest<ExercizeCD>()
        fetchRequest.entity = entity
        todaysWorkouts = []
        allWorkouts = try! managedObjectContext.fetch(fetchRequest)
        
            for exercise in allWorkouts{
                
                if exercise.section == "\(getDayOfWeek(today: todaysDate)!)"{
                    todaysWorkouts.append(exercise)
                }
            }
        tableView.reloadData()
    }
    
    var weight_unit = UserDefaults.standard.value(forKey: "Unit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTodaysWorkOuts()
        //code from stack overflow - get rid of  empty cells
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.breakDownCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.breakDownCell)
        tableView.tableFooterView = UIView()
        title = "\(dayOfWeek(date))'s Workout"
    }
    
    func countExercises() -> Int {
        let amountOfExercises = 0
        return amountOfExercises
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todaysWorkouts.count == 0 {
            return 1
        }
        return todaysWorkouts.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if todaysWorkouts.count == 0{
            self.tableView.rowHeight = 100;
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        }
        self.tableView.rowHeight = 150;
        if indexPath.row == 0 {
            self.tableView.rowHeight = 200;
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.breakDownCell) as! BreakDownCell
            cell.configure(for: todaysWorkouts)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:
        "ExercisesCell2", for: indexPath) as! TodaysExercisesCell
        let workoutCD = todaysWorkouts[indexPath.row-1]
        if todaysWorkouts[indexPath.row-1].finished && todaysWorkouts[indexPath.row-1].failed{
            cell.backgroundColor = UIColor(hex: "#f59d87ff")
        }
        if todaysWorkouts[indexPath.row-1].finished && !todaysWorkouts[indexPath.row-1].failed{
            cell.backgroundColor = UIColor(hex: "#9BDDCCff")
        }
        if !todaysWorkouts[indexPath.row-1].finished{
            cell.backgroundColor = UIColor(hex: "#ffffffff")
        }
        let workout = Exercise()
        workout.name = workoutCD.name
        workout.id = Int(workoutCD.id)
        workout.day = sectionToDay(workoutCD.section)
        workout.reps = Int(workoutCD.reps)
        workout.sets = Int(workoutCD.sets)
        workout.weightLBs = workoutCD.weight
        workout.weightKGs = workoutCD.weightKG
        workout.image = workoutCD.image
        workout.muscles = workoutCD.muscles
        workout.muscles_secondary = workoutCD.muscles_secondary
        workout.equipment = workoutCD.equipment
        cell.configure(for: workout, myUnit: weight_unit as! String)
                return cell
    }
    
    override func tableView(_ tableView: UITableView,
                        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0{
            let entity = ExercizeCD.entity()
            let fetchRequest = NSFetchRequest<ExercizeCD>()
            fetchRequest.entity = entity
            print(try! managedObjectContext.fetch(fetchRequest))
            return nil
        }
        if !todaysWorkouts[indexPath.row-1].finished{
            let refreshAlert = UIAlertController(title: "Complete this workout!", message: "If you pass this work out, next time we'll ask you to do 5 more pounds (or 2.5 KGs more).", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Passed", style: .default, handler: { (action: UIAlertAction!) in
                    self.todaysWorkouts[indexPath.row-1].weight += 5.0
                    self.todaysWorkouts[indexPath.row-1].weightKG += 2.5
                    self.todaysWorkouts[indexPath.row-1].finished = true
                    tableView.reloadData()
                    do{
                        try self.managedObjectContext.save()
                    }
                    catch {
                        fatalCoreDataError(error)
                    }
            }))

            refreshAlert.addAction(UIAlertAction(title: "Failed", style: .default, handler: { (action: UIAlertAction!) in
                if(self.todaysWorkouts[indexPath.row-1].weight > 10 &&
                    self.todaysWorkouts[indexPath.row-1].weightKG > 10){
                    self.todaysWorkouts[indexPath.row-1].weight -= 15.0
                    self.todaysWorkouts[indexPath.row-1].weightKG -= 7.0
                    self.todaysWorkouts[indexPath.row-1].finished = true
                    self.todaysWorkouts[indexPath.row-1].failed = true
                    tableView.reloadData()
                    do{
                        try self.managedObjectContext.save()
                    }
                    catch {
                        fatalCoreDataError(error)
                    }
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    //print("Cancelled")
            }))

            present(refreshAlert, animated: true, completion: nil)
            return indexPath
            }
        else{
            let finishedAlert = UIAlertController(title: "You completed this already!", message: "This work out has been completed by you already and has been marked as complete!.", preferredStyle: UIAlertController.Style.alert)
            finishedAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action: UIAlertAction!) in
                    //print("Cancelled")
            }))
            present(finishedAlert, animated: true, completion: nil)
            return nil
        }
        
    }

    
    struct TableView{
        struct CellIdentifiers {
            static let nothingFoundCell = "NothingFoundCell"
            static let breakDownCell = "BreakDownCell"
        }
    }
}
