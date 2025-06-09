//
//  No_Fap_AppleApp.swift
//  No Fap Apple
//
//  Created by Marshall Hodge on 5/27/25.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Handle shortcut launch
        if let shortcutItem = options.shortcutItem {
            DispatchQueue.main.async {
                ShortcutHandler.shared.handleShortcut(shortcutItem.type)
            }
        }
        
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        ShortcutHandler.shared.handleShortcut(shortcutItem.type)
        completionHandler(true)
    }
}

@main
struct No_Fap_AppleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var shortcutHandler = ShortcutHandler.shared
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(shortcutHandler)
        }
    }
}
