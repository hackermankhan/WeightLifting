//
//  ExercizeCD+CoreDataProperties.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 12/9/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//
//

import Foundation
import CoreData


extension ExercizeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExercizeCD> {
        return NSFetchRequest<ExercizeCD>(entityName: "ExercizeCD")
    }

    @NSManaged public var date: Date
    @NSManaged public var equipment: [Int]
    @NSManaged public var id: Int16
    @NSManaged public var image: String
    @NSManaged public var muscles: [Int]
    @NSManaged public var muscles_secondary: [Int]
    @NSManaged public var name: String
    @NSManaged public var reps: Int16
    @NSManaged public var section: String
    @NSManaged public var sets: Int16
    @NSManaged public var weight: Float
    @NSManaged public var weightKG: Float
    @NSManaged public var finished: Bool
    @NSManaged public var failed: Bool

}
