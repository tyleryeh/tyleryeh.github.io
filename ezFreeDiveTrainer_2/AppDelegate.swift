//
//  AppDelegate.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/18.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        print("\(NSHomeDirectory())")
        
        let dic = ["isFirstOpenApp": true]
        UserDefaults.standard.register(defaults: dic)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //按下登入鈕後，畫面會跳轉到網頁，進行帳號密碼確認，此方法實作確認完帳號密碼後，畫面跳轉回原ViewController
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //Facebook
        ApplicationDelegate.shared.application(app, open: url, options: options)
        
        //goole
        return GIDSignIn.sharedInstance().handle(url)
    }


}

