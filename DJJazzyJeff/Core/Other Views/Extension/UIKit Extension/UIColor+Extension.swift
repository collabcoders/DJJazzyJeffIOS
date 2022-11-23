//
//  UIColor+Extension.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import UIKit


//Never user Color enum directly, use UIColor's Extenion's property only
enum Color {
    static let primary = UIColor(named: "primary")
    static let secondary = UIColor(named: "secondary")
    static let secondary_dark = UIColor(named: "secondary_dark")
    static let red_main = UIColor(named: "red_main")
    
    
}

extension UIColor{
    static let primary = Color.primary
    static let secondary = Color.secondary
    static let secondary_dark = Color.secondary_dark
    static let red_main = Color.red_main
}
