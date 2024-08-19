//
//  String+Extensions.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation

extension String {
    
    func isNumeric() -> Bool {
        for c in self {
            if !c.isNumber {
                return false
            }
        }
        return true
    }
    
}
