//
//  NameCategoryPickerViewController.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/16/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import UIKit
class NameCategoryPickerViewController: SetCategoryPickerViewController{
    
    //get this method of overriding from stack overflow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allImages("exerciseimage/?format=json&is_main=True&limit=200")
        allImages("exercise/?format=json&language=2&limit=250")
        categories = [firstItem, "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading..."]
        
        
        
        //code from stack overflow - get rid of  empty cells
        tableView.tableFooterView = UIView()
      for i in 0..<categories.count {
        if categories[i] == selectedCategorySet {
          selectedIndexPath = IndexPath(row: i, section: 0)
    break
    } }
    }
    
    //our images and excerices
    var excercise_image_pair = [Int: String]()
    
    //only the workouts with images
    var name_image_pair = [String]()
    var exercises_acceptable = [Exercise]()
    
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "PickedName" {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
          selectedCategorySet = categories[indexPath.row]
            thisExercise = exercises_acceptable[indexPath.row]
        }
    } }
    
    func allImages(_ my_url: String) -> [Exercise] {
        let url = workOutURL(searchText: my_url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error{
                print("Failure! \(error.localizedDescription)")
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        if my_url == "exerciseimage/?format=json&is_main=True&limit=200"
                        {
                            let results: [imageFiles] = self.parseImages(data: data)
                            for imageFile in results{
                                if self.excercise_image_pair[imageFile.exercise] != nil{
                                    //print(imageFile.exercise, imageFile.image)
                                }
                                else{
                                    self.excercise_image_pair[imageFile.exercise] = imageFile.image
                                }
                            }
                            //print(self.excercise_image_pair.count)
                        }
                        else if my_url == "exercise/?format=json&language=2&limit=250"
                        {
                            let results: [ExerciseData] = self.parseExercise(data: data)
                            self.categories = []
                            for result in results {
                                let exerciseID = result.id
                                if let val = self.excercise_image_pair[exerciseID] {
                                let exerciseName = result.name
                                let exerciseMuscles = result.muscles
                                let exerciseMusclesSecondary = result.muscles_secondary
                                let exerciseEquipment = result.equipment
                                //print(exerciseName)
                                self.categories.append(exerciseName)
                                    //create exercise
                                    let newExercise = Exercise()
                                    newExercise.name = exerciseName
                                    newExercise.id = exerciseID
                                    newExercise.muscles = exerciseMuscles
                                    newExercise.muscles_secondary = exerciseMusclesSecondary
                                    newExercise.equipment = exerciseEquipment
                                    newExercise.image = self.excercise_image_pair[exerciseID] ?? ""
                                    self.exercises_acceptable.append(newExercise)
                                }
                                
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        //self.isLoading = false
                        self.tableView.reloadData()
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
        return [Exercise()]
    }
    
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
    
    //parse each exerise
    func parseExercise(data: Data) -> [ExerciseData] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultExerciseArray.self, from:data)
            return result.results
        }
        catch{
            print("JSON Error: \(error)")
            return []
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
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
              willSelectRowAt indexPath: IndexPath)
              -> IndexPath? {
                if(categories[1] == "Loading..."){
                    return nil
                }
                return indexPath
    }
}
