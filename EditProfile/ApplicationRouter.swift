//
//  ApplicationRouter.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

class ApplicationRouter {
    
    static var shared = ApplicationRouter()
    
    var window: UIWindow?
    
    private init() {}
    
    func start() {
        showMain()
    }
    
    private func showMain() {
        let mainViewController: MainViewController = UIStoryboard.storyboardMain.instantiateViewController(ofType: MainViewController.self)
        let startNavigation = UINavigationController(rootViewController: mainViewController)
        open(startNavigation)
    }
    
    private func open(_ vc: UIViewController) {
        guard let window = window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {})
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
}
