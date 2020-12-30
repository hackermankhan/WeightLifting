//
//  FirstViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 10/11/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit
import CoreData



var date = Date()
let todaysDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)

class CurrentWorkoutOutViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    //var weight_unit = "Pounds (Lbs)"
    var weight_unit = UserDefaults.standard.value(forKey: "Unit")
    
    //work outs that were saved with CoreData
    lazy var fetchedResultsController:
           NSFetchedResultsController<ExercizeCD> = {
    let fetchRequest = NSFetchRequest<ExercizeCD>()
    let entity = ExercizeCD.entity()
    fetchRequest.entity = entity
            let sort1 = NSSortDescriptor(key: "section", ascending: true)
            let sort2 = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sort1, sort2]
    fetchRequest.fetchBatchSize = 20
    let fetchedResultsController = NSFetchedResultsController(
              fetchRequest: fetchRequest,
      managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: "section", cacheName: "Workouts")
            fetchedResultsController.delegate = self
              return fetchedResultsController
    }()
    
    deinit {
        fetchedResultsController.delegate = nil
    }
    
    var myWorkouts = [Exercise]()
    var mySectionedWorkouts = [Int: [Exercise]]()
    var exercisesFound = true
    var imageDict = [Int:String]()
    var imageArrayDict = [Int:[String]]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitLabel.text = "Current Unit: \(weight_unit ?? "")"
        performFetch()
        if fetchedResultsController.fetchedObjects?.count == 0 {
            workoutLabel.text = "No Workouts Saved"
        }
        else{
            workoutLabel.text = "Your Saved Workouts:"
        }
        // Do any additional setup after loading the view.
        //code from stack overflow - get rid of  empty cells
        //tableView.tableFooterView = UIView()
        
        getWorkouts(true)
    }
    
    
    func performFetch() {
      do {
        try fetchedResultsController.performFetch()
      } catch {
        fatalCoreDataError(error)
      }
    }
    
    //get a valid url for the API
    //exerciseimage/?format=json&is_main=True&limit=250 for images
    func workOutURL(searchText: String) -> URL {
        let urlString = String(format: "https://wger.de/api/v2/%@", searchText)
        let url = URL(string: urlString)
        return url!
    }
    
    //get info from API
    func performRequest(with url: URL) -> Data?{
        do{
            return try Data(contentsOf: url)
        }catch{
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    
    
    //parse info
    func parseImages(data: Data) -> [imageFiles] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResultImageArray.self, from:data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
        return [] }
    }
    
    func updateTite(){
        if fetchedResultsController.fetchedObjects?.count == 0 {
            workoutLabel.text = "No Workouts Saved"
        }
        else{
            workoutLabel.text = "Your Saved Workouts:"
        }
    }
    
    func load_AB(){
        if let savedWorkouts = fetchedResultsController.fetchedObjects{
        for exercise in savedWorkouts{
                //print(exercise.name)
                let myExercise = Exercise()
                myExercise.name = exercise.name
                myExercise.id = Int(exercise.id)
                myExercise.weightLBs = exercise.weight
                myExercise.weightKGs = exercise.weightKG
                myExercise.reps = Int(exercise.reps)
                myExercise.sets = Int(exercise.sets)
                myExercise.day = exercise.section
                myWorkouts.append(myExercise)
                //print(exercise.section)
                if numToDay(Int(exercise.section)!) != dayOfWeek(date){
                    exercise.finished = false
                }
            }
            
        }
    }
    
    
    @IBAction func categoryDidPickUnit(_ segue: UIStoryboardSegue) {
            let controller = segue.source as! SettingsViewController
            let unit = controller.selectedCategorySet
            let userDefaults = UserDefaults.standard
            if unit == "LBs"{
                    weight_unit = "LBs"
            }
            else{
                    weight_unit = "KGs"
            }
            unitLabel.text = "Current Unit: \(weight_unit ?? "")"
            userDefaults.set(self.weight_unit, forKey: "Unit")
            userDefaults.synchronize()
        tableView.reloadData()
    }
    
    func getWorkouts(_ reload: Bool){
        myWorkouts = []
        load_AB()
        let url = self.workOutURL(searchText: "exerciseimage/?format=json&is_main=True&limit=200")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error{
                print("Failure! \(error.localizedDescription)")
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        let results: [imageFiles] = self.parseImages(data: data)
                        //print(results)
                        self.associateImages(results)
                        //print(self.imageDict.count)
                    }
                    DispatchQueue.main.async {
                        //self.isLoading = false
                        if reload == true{
                            self.tableView.reloadData()
                        }
                    }
                    return
                }
            }
            else{
                print("Failure! \(response!)")
            }
            DispatchQueue.main.async {
                //self.isLoading = false
                self.tableView.reloadData()
                self.showNetworkError()
            }
        })
        dataTask.resume()
    }
    
    // MARK:- Navigation to next screen
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "NewExercise" {
        let controller = segue.destination
                         as! ExerciseDetailViewController
        controller.managedObjectContext = managedObjectContext
        controller.categoryDay = dayOfWeek(date)
      }
        if segue.identifier == "EditExercise" {
            let controller = segue.destination as! ExerciseDetailViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let workoutCD = fetchedResultsController.object(at: indexPath)
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
                controller.exerciseToEdit = workout
                let exerciseCD: ExercizeCD
                exerciseCD = fetchedResultsController.object(at: indexPath)
                controller.exerciseToEditCD = exerciseCD
                controller.categorySet = "\(workout.sets)"
                controller.categoryRep = "\(workout.reps)"
                controller.categoryDay = "\(workout.day)"
            }
        }
        if segue.identifier == "PickUnit"{
            let controller = segue.destination as!
                             SetCategoryPickerViewController
            controller.selectedCategorySet = weight_unit as! String
        }
    }
    
    //textbook code chapter 39
    func showNetworkError() {
          let alert = UIAlertController(title: "Whoops...",
            message: "There was an error accessing our workouts." +
            " Please try again.", preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default,
                                 handler: nil)
        present(alert, animated: true, completion: nil)
          alert.addAction(action)
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let nothingFoundCell = "NothingFoundCell"
        }
    }

}

extension CurrentWorkoutOutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if myWorkouts.count > 0{
            return myWorkouts.count
        }
        return 0*/
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier:
            "ExercisesCell", for: indexPath) as! ExercisesCell
            let workoutCD = fetchedResultsController.object(at: indexPath)
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
    
    
    func associateImages(_ results: [imageFiles]){
        //build image dictionary
        for imageFile in results{
            if self.imageDict[imageFile.exercise] != nil{
                //print(imageFile.exercise, imageFile.image)
            }
            else{
                self.imageDict[imageFile.exercise] = imageFile.image
            }
        }
        //set images to each work out
        for exercise in myWorkouts{
            let exerciseID = exercise.id
            exercise.image = imageDict[exerciseID]!
        }
    }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView,
                  commit editingStyle: UITableViewCell.EditingStyle,
                  forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
            let location = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(location)
        
        do {
           try managedObjectContext.save()
            
        } catch {
          fatalCoreDataError(error)
        }
    } }
    
    
    func numberOfSections(in tableView: UITableView)
                  -> Int {
        fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView,
                titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionToDay(sectionInfo.name)
    }
    
}

//helper
func sectionToDay(_ day: String) -> String{
    if day == "2"{
        return "Monday"
    }
    if day == "3"{
        return "Tuesday"
    }
    if day == "4"{
        return "Wednesday"
    }
    if day == "5"{
        return "Thursday"
    }
    if day == "6"{
        return "Friday"
    }
    if day == "7"{
        return "Saturday"
    }
        return "Sunday"
}

// MARK:- NSFetchedResultsController Delegate Extension
extension CurrentWorkoutOutViewController:
          NSFetchedResultsControllerDelegate {
      func controllerWillChangeContent(_ controller:
              NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
      }
  func controller(_ controller:
          NSFetchedResultsController<NSFetchRequestResult>,
          didChange anObject: Any, at indexPath: IndexPath?,
          for type: NSFetchedResultsChangeType,
          newIndexPath: IndexPath?) {
        switch type {
        case .insert:
          print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
          
        case .delete:
          print("*** NSFetchedResultsChangeDelete (object)")
          tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
          print("*** NSFetchedResultsChangeUpdate (object)")
          
          if let cell = tableView.cellForRow(at: indexPath!)
                                          as? ExercisesCell {
                let workoutCD = controller.object(at: indexPath!)
                               as! ExercizeCD
                let workout = Exercise()
                workout.id = Int(workoutCD.id)
                workout.name = workoutCD.name
                workout.reps = Int(workoutCD.reps)
                workout.sets = Int(workoutCD.sets)
                workout.weightLBs = workoutCD.weight
                workout.weightKGs = workoutCD.weightKG
                workout.image = workoutCD.image
                workout.muscles = workoutCD.muscles
                workout.muscles_secondary = workoutCD.muscles_secondary
                workout.equipment = workoutCD.equipment
                workout.day = sectionToDay(workoutCD.section)
            cell.configure(for: workout, myUnit: weight_unit as! String)
            }
            
        case .move:
          print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
    func controller(_ controller:
          NSFetchedResultsController<NSFetchRequestResult>,
          didChange sectionInfo: NSFetchedResultsSectionInfo,
          atSectionIndex sectionIndex: Int,
          for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
              print("*** NSFetchedResultsChangeInsert (section)")
              tableView.insertSections(IndexSet(integer: sectionIndex),
        with: .fade)
            case .delete:
              print("*** NSFetchedResultsChangeDelete (section)")
              tableView.deleteSections(IndexSet(integer: sectionIndex),
        with: .fade)
            case .update:
              print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
              print("*** NSFetchedResultsChangeMove (section)")
            @unknown default:
              fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
  func controllerDidChangeContent(_ controller:
          NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerDidChangeContent")
    updateTite()
    tableView.endUpdates()
  }
}
