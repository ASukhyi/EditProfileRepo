//
//  Storyboard+Extensions.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

extension UIStoryboard {
    
    static var storyboardMain: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T {
        let storyboardID = String(describing: type)
        
        guard let viewController = instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("Could not instantiate view controller with identifier \(storyboardID) of type \(T.self).")
        }
        
        return viewController
    }
    
}
