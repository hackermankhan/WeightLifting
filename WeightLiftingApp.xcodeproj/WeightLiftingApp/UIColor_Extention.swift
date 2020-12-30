//
//  UIColor_Extention.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 12/9/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    /*code from https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor?fbclid=IwAR1Z9JZtflSLC0UdAYiTqqrL8uwC4lF6XnfZOcDBAu7uDaOZKoOG7jsdJZM */
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
