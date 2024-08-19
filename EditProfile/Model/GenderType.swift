//
//  GenderType.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation

enum GenderType: Int, CaseIterable {
    case male = 0
    case female = 1
    case other = 2
    
    func title() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        }
    }
    
}
