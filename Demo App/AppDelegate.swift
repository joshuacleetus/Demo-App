//
//  AppDelegate.swift
//  Demo App
//
//  Created by Joshua Cleetus on 4/29/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let viewModel = CharactersViewModel(api: URLSessionCharactersAPI())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        viewModel.fetchCharacters()
        // Set up your window and root view controller here
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = CharactersViewController(viewModel: viewModel)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
        return true
    }

}

