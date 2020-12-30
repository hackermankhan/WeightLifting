//
//  ExerciseImage.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/15/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation

class ResultImageArray: Codable {
    var count = 0
    var results = [imageFiles]()
}

class imageFiles: Codable, CustomStringConvertible {
    var exercise = 0
    var image = ""
    var description: String{
        return "Exercise ID: \(exercise), image: \(image)"
    }
}
