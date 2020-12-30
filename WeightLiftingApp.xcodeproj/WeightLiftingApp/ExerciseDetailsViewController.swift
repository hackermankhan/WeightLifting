//
//  ExerciseDetailsViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/15/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation
import AudioToolbox

class ExerciseDetailViewController: UITableViewController, EditWeightControllerDelegate {
    
    
    var notificationSoundLookupTable = [String: SystemSoundID]()
    
    enum SoundExtension : String{
       case caf
       case aif
       case wav
    }
    
    func play(sound: String, ofType type: SoundExtension) {
       if let soundID = notificationSoundLookupTable[sound] {
          AudioServicesPlaySystemSound(soundID)
       } else {
          if let soundURL : CFURL = Bundle.main.url(forResource: sound,       withExtension: type.rawValue) as CFURL? {
             var soundID  : SystemSoundID = 0
             let osStatus : OSStatus = AudioServicesCreateSystemSoundID(soundURL, &soundID)
             if osStatus == kAudioServicesNoError {
                AudioServicesPlaySystemSound(soundID);
                notificationSoundLookupTable[sound] = (soundID)
             }else{
                // This happens in exceptional cases
                // Handle it with no sound or retry
             }
          }
       }
    }
    
    func disposeSoundIDs() {
       for soundID in notificationSoundLookupTable.values {
          AudioServicesDisposeSystemSoundID(soundID)
       }
    }
    
    var managedObjectContext: NSManagedObjectContext!
    var exerciseToEdit: Exercise? {
        didSet{
            if let exercise = exerciseToEdit{
                currentExercise = exercise
            }
        }
    }
    var exerciseToEditCD: ExercizeCD?
    
    var player: AVAudioPlayer?
    
    var date = Date()
    
    func editHighScoreViewControllerDidCancel(_ controller: EditWeightViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func editHighScoreViewController(_ controller: EditWeightViewController, didFinishEditing item: Float) {
        let myweight: String = weight_unit as! String
        if myweight == "LBs"{
            currentExercise.weightLBs = item
            currentExercise.weightKGs = roundNearestPointFive(item / 2.2)
            weightLabel.text = "\(currentExercise.weightLBs) \(weight_unit ?? "")"
        }
        else{
            currentExercise.weightKGs = item
            currentExercise.weightLBs = roundNearestPointFive(item * 2.2)
            weightLabel.text = "\(currentExercise.weightKGs) \(weight_unit ?? "")"
        }
        //weight = currentExercise.weightLBs
        
        navigationController?.popViewController(animated: true)
    }
    
    func roundNearestPointFive(_ num: Float) -> Float {
        let decimal: Float = num - floor(num)
        if(decimal < 0.25)
        {
            return floor(num)
        }
        else if(decimal > 0.25 && decimal <= 0.5){
            return floor(num) + 0.5
        }
        else{
            return ceil(num)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    
    var currentExercise = Exercise()
    var categorySet = "1"
    var categoryRep = "3"
    var categoryName = "None"
    var categoryDay = "Monday"
    //var weight: Float = 55.0
    var weight_unit = UserDefaults.standard.value(forKey: "Unit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updating all the labels
        if let exercise = exerciseToEditCD{
            title = "Edit Exercise"
        }
        updateLabels()
    }
    
    func updateLabels(){
        if(currentExercise.id == 0)
        {
            nameLabel.text = "Choose an exercise"
            weightLabel.text = "Choose starting weight"
            setsLabel.text = "Choose sets"
            repsLabel.text = "Choose reps"
            dayLabel.text = "Which day?"
            musclesLabel.text = "No exercise selected..."
            equipmentLabel.text = "No exercise selected..."
        }
        else{
            nameLabel.text = currentExercise.name
            let weight: String = weight_unit as! String
            if(weight == "LBs"){
                weightLabel.text = "\(currentExercise.weightLBs) \(weight_unit ?? "")"
            }
            else{
                weightLabel.text = "\(currentExercise.weightKGs) \(weight_unit ?? "")"
            }
            setsLabel.text = "\(currentExercise.sets)"
            repsLabel.text = "\(currentExercise.reps)"
            dayLabel.text = "\(currentExercise.day)"
            musclesLabel.text = "\(extractString(exercise: currentExercise, type: "Muscles"))"
            equipmentLabel.text = "Needed equipment: \(extractString(exercise: currentExercise, type: "Equipment"))"
            firstImage.image = UIImage(named: "Placeholder")
            if let smallURL = URL(string: currentExercise.image) {
              downloadTask = firstImage.loadImage(url: smallURL)
            }
            
        }
    }
    
    @IBAction func categoryDidPickSet(_ segue: UIStoryboardSegue) {
          let controller = segue.source as! SetCategoryPickerViewController
          categorySet = controller.selectedCategorySet
          currentExercise.sets = Int(categorySet) ?? 1
          setsLabel.text = "\(currentExercise.sets)"
    }
    
    @IBAction func categoryDidPickRep(_ segue: UIStoryboardSegue) {
          let controller = segue.source as! RepsCategoryPickerViewController
          categoryRep = controller.selectedCategorySet
          currentExercise.reps = Int(categoryRep) ?? 1
          repsLabel.text = "\(currentExercise.reps)"
    }
    
    @IBAction func categoryDidPickDay(_ segue: UIStoryboardSegue) {
          let controller = segue.source as! DayCategoryPickerViewController
          categoryDay = controller.selectedCategorySet
          currentExercise.day = categoryDay
          dayLabel.text = "\(currentExercise.day)"
    }
    
    @IBAction func categoryDidPickName(_ segue: UIStoryboardSegue) {
          let controller = segue.source as! NameCategoryPickerViewController
          categoryName = controller.selectedCategorySet
            currentExercise = controller.thisExercise
          //nameLabel.text = "\(currentExercise.name)"
        updateLabels()
    }
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                           sender: Any?) {
        if segue.identifier == "PickSets" {
          let controller = segue.destination as!
                           SetCategoryPickerViewController
          controller.selectedCategorySet = categorySet
            //print(categorySet)
        }
        else if segue.identifier == "PickReps" {
          let controller = segue.destination as!
                           RepsCategoryPickerViewController
          controller.selectedCategorySet = categoryRep
        }
            
        else if segue.identifier == "PickName" {
                let controller = segue.destination as! NameCategoryPickerViewController
                controller.selectedCategorySet = categoryName
                controller.firstItem = categoryName
        }
        else if segue.identifier == "PickWeight" {
            let controller = segue.destination as! EditWeightViewController
            controller.delegate = self
        }
        else if segue.identifier == "PickDay" {
            let controller = segue.destination as! DayCategoryPickerViewController
            controller.selectedCategorySet = categoryDay
        }
    }
    
    func showError() {
          let alert = UIAlertController(title: "Hold on!",
            message: "You didn't select anything... \n" +
            "Please select from the various work outs.", preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default,
                                 handler: nil)
        present(alert, animated: true, completion: nil)
          alert.addAction(action)
    }
    
    //helper
    func dayToSection(_ day: String) -> String{
        if day == "Monday"{
            return "2"
        }
        if day == "Tuesday"{
            return "3"
        }
        if day == "Wednesday"{
            return "4"
        }
        if day == "Thursday"{
            return "5"
        }
        if day == "Friday"{
            return "6"
        }
        if day == "Saturday"{
            return "7"
        }
            return "1"
    }
    
    //MARK:- Actions
    @IBAction func done(){
        //navigationController?.popViewController(animated: true)
        if(nameLabel.text != "Choose an excersize")
        {
            //play(sound: "ShortRing", ofType: .wav)
            if let player = player, player.isPlaying{
                //stop playback
            }
            else{
                let urlString = Bundle.main.path(forResource: "ding", ofType: "mp3")
                
               /* do{
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    guard let urlString = urlString else{
                        return
                    }
                    player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                    guard let player = player else{
                        return
                    }
                    player.play()
                }
                catch{
                        print("Something went wrong")
                }*/
            }
            let hudView = HudView.hud(inView: navigationController!.view, animated: true)
            //audioPlayer.play()
            let exercise: ExercizeCD
            if let temp = exerciseToEditCD {
                hudView.text = "Updated!"
                temp.sets = Int16(currentExercise.sets)
                temp.reps = Int16(currentExercise.reps)
                temp.weight = currentExercise.weightLBs
                temp.weightKG = currentExercise.weightKGs
                temp.id = Int16(currentExercise.id)
                temp.section = dayToSection(currentExercise.day)
                temp.name = currentExercise.name
                temp.equipment = currentExercise.equipment
                temp.image = currentExercise.image
                temp.muscles = currentExercise.muscles
                temp.muscles_secondary = currentExercise.muscles_secondary
                exercise = temp
                exercise.finished = false
                exercise.failed = false
                //print(exercise)
            }
            else{
            // save the exercise
                hudView.text = "Added!"
                exercise = ExercizeCD(context: managedObjectContext)
                exercise.sets = Int16(currentExercise.sets)
                exercise.reps = Int16(currentExercise.reps)
                exercise.section = dayToSection(currentExercise.day)
                exercise.weight = currentExercise.weightLBs
                exercise.weightKG = currentExercise.weightKGs
                exercise.date = date
                exercise.id = Int16(currentExercise.id)
                exercise.image = currentExercise.image
                exercise.muscles = currentExercise.muscles
                exercise.muscles_secondary = currentExercise.muscles_secondary
                exercise.equipment = currentExercise.equipment
                exercise.name = currentExercise.name
                exercise.finished = false
                exercise.failed = false
            }
            do{
                try managedObjectContext.save()
                afterDelay(0.8) {
                    hudView.hide()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            catch {
                fatalCoreDataError(error)
            }
            
        }
        else{
            showError()
        }
    }
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let exercise = exerciseToEditCD{
            if indexPath.row == 0{
                return nil
            }
        }
      return indexPath
    }
}
