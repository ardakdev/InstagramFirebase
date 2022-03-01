//
//  UIColor+.swift
//  InstagramFirebase
//
//  Created by Ardak on 16.02.2022.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        return color
    }
}
