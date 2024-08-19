//
//  AppDelegate.swift
//  EditProfile
//
//  Created by Andrii on 8/16/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRouter()
        return true
    }
    
    private func setupRouter() {
        window = .init(frame: UIScreen.main.bounds)
        ApplicationRouter.shared.window = window
        ApplicationRouter.shared.start()
    }

}

