//
//  KeepUp_App.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 21/08/23.
//

import SwiftUI
import Firebase
import Combine

@main
struct KeepUp_App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

class UserSettings: ObservableObject {
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    
    @Published var buttonCount: Int {
        didSet {
            UserDefaults.standard.set(buttonCount, forKey: "buttonCount")
        }
    }
    
    @Published var buttonTitles: [String] {
        didSet {
            UserDefaults.standard.set(buttonTitles, forKey: "buttonTitles")
        }
    }
    
    @Published var lastUpdatedTimestamp: Date? {
            didSet {
                UserDefaults.standard.set(lastUpdatedTimestamp, forKey: "lastUpdatedTimestamp")
            }
        }
    
    init() {
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.buttonCount = UserDefaults.standard.integer(forKey: "buttonCount")
        self.buttonTitles = UserDefaults.standard.stringArray(forKey: "buttonTitles") ?? Array(repeating: "", count: 10)
        if let savedDate = UserDefaults.standard.object(forKey: "lastUpdatedTimestamp") as? Date {
            lastUpdatedTimestamp = savedDate
        }
    }
}


