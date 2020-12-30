//
//  Functions.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/21/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let CoreDataSaveFailedNotification = Notification.Name("CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return paths[0]
}()

func dayOfWeek(_ date: Date) -> String{
    //get day of week
    return numToDay(getDayOfWeek(today: todaysDate)!)
}

//code from stackoverflow user:  Martin R
func getDayOfWeek(today: String) -> Int? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.dateFormat = "MM/dd/yy"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    return weekDay
}

func numToDay(_ day: Int) -> String {
    if day == 1{
        return "Sunday"
    }
    else if day == 2{
        return "Monday"
    }
    else if day == 3{
        return "Tuesday"
    }
    else if day == 4{
        return "Wednesday"
    }
    else if day == 5{
        return "Thursday"
    }
    else if day == 6{
        return "Friday"
    }
    return "Saturday"
}

//MARK:- Helper Methods
func extractString(exercise currExercise: Exercise, type m_e: String) -> String {
    if (currExercise.equipment.count > 0 && m_e == "Equipment") || ((currExercise.muscles.count > 0 || currExercise.muscles_secondary.count > 0) && m_e != "Equipment"){
        if(m_e == "Equipment"){
            switch currExercise.equipment[0]{
                case 1:
                    return "Barbell"
                case 2:
                    return "SZ-Bar"
                case 8:
                    return "Bench"
                case 3:
                    return "Dumbbell"
                case 4:
                    return "Gym mat"
                case 9:
                    return "Incline bench"
                case 10:
                    return "Kettlebell"
                case 7:
                    return "Body weight"
                case 6:
                    return "Pull-up Bar"
                case 5:
                    return "Swiss Ball"
                default:
                    return "External Equipment"
            }
        }
        else{
            var all_muscles_code = currExercise.muscles
            var all_muscles = "Muscles: "
            for muscle_s in currExercise.muscles_secondary{
                all_muscles_code.append(muscle_s)
            }
            for muscle in all_muscles_code{
                switch muscle{
                case 2:
                    all_muscles += "Anterior deltoid, "
                case 1:
                    all_muscles += "Bicep brachii, "
                case 11:
                    all_muscles += "Biceps femoris, "
                case 13:
                    all_muscles += "Brachialis, "
                case 7:
                    all_muscles += "Gastrocnemius, "
                case 8:
                    all_muscles += "Gluteus maximus, "
                case 12:
                    all_muscles += "Latissimus dorsi, "
                case 14:
                    all_muscles += "Obliquus externus abdominis, "
                case 4:
                    all_muscles += "Pectoralis major, "
                case 10:
                    all_muscles += "Quadriceps femoris, "
                case 6:
                    all_muscles += "Rectus abdominus, "
                case 3:
                    all_muscles += "Serratus anterior, "
                case 15:
                    all_muscles += "Soleus, "
                case 9:
                    all_muscles += "Trapezius, "
                case 5:
                    all_muscles += "Triceps brachii, "
                default:
                    return "null data"
                }
            }
            //stack overflow user: Leo Dabus
                
                return String(all_muscles.dropLast(2))
        }
    }
    if m_e == "Equipment"{
        return "No external portable equipment, this is body or machine work out."
    }
    return "No relevant data available at this time"
}
