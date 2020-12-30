//
//  ExerciseInfo.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/14/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation

class ResultExerciseArray: Codable {
    var count = 0
    var results = [ExerciseData]()
}

class ExerciseData: Codable, CustomStringConvertible {
    var id = 0
    var name = ""
    var category = 0
    var muscles = [Int]()
    var muscles_secondary = [Int]()
    var equipment = [Int]()
    
    
    var description: String{
        return "ID: \(id) \n Name: \(name) \n Muscles = \(muscles)"
    }
}
