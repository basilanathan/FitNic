//  AppDelegate.swift
//  Fitnic

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - Daily Workout notification
    func doCreateWorkoutNotification() {
        UIApplication.shared.cancelAllLocalNotifications()
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: Date! = Calendar.current.date(byAdding: .day, value: 1, to: Date() as Date)!

        // Beginner
        let strBegin = UserDefaults.standard.string(forKey: "Beginner")
        let daysBegin = UserDefaults.standard.integer(forKey: "Beginner"+"day")
        if (strBegin?.characters.count)! > 0 && daysBegin > 0 {
            let notification: UILocalNotification = UILocalNotification()
            notification.alertBody = "Hey, This is Day \(daysBegin+1) of 30 day workout challenge - Beginner"
            notification.timeZone = NSTimeZone.default
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now, options: NSCalendar.Options.matchFirst)!
            notification.repeatInterval = NSCalendar.Unit(rawValue: 0)
            UIApplication.shared.scheduleLocalNotification(notification)
        }

        // Intermediate
        let strInter = UserDefaults.standard.string(forKey: "Intermediate")
        let daysInter = UserDefaults.standard.integer(forKey: "Intermediate"+"day")
        if (strInter?.characters.count)! > 0 && daysInter > 0 {
            let notification: UILocalNotification = UILocalNotification()
            notification.alertBody = "Hey, This is Day \(daysInter+1) of 30 day workout challenge - Intermediate"
            notification.timeZone = NSTimeZone.default
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now, options: NSCalendar.Options.matchFirst)!
            notification.repeatInterval = NSCalendar.Unit(rawValue: 0)
            UIApplication.shared.scheduleLocalNotification(notification)
        }

        // Advanced
        let strAdv = UserDefaults.standard.string(forKey: "Advanced")
        let daysAdv = UserDefaults.standard.integer(forKey: "Advanced"+"day")
        if (strAdv?.characters.count)! > 0 && daysAdv > 0 {
            let notification: UILocalNotification = UILocalNotification()
            notification.alertBody = "Hey, This is Day \(daysAdv+1) of 30 day workout challenge - Advanced"
            notification.timeZone = NSTimeZone.default
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: now, options: NSCalendar.Options.matchFirst)!
            notification.repeatInterval = NSCalendar.Unit(rawValue: 0)
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    // MARK: - UIApplication delegate Methods
    public func applicationDidEnterBackground(_ application: UIApplication) {
        self.doCreateWorkoutNotification()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()

        if UserDefaults.standard.string(forKey: "Beginner") == nil {
            UserDefaults.standard.set("", forKey: "Beginner")
        }
        if UserDefaults.standard.string(forKey: "Intermediate") == nil {
            UserDefaults.standard.set("", forKey: "Intermediate")
        }
        if UserDefaults.standard.string(forKey: "Advanced") == nil {
            UserDefaults.standard.set("", forKey: "Advanced")
        }

        if UserDefaults.standard.string(forKey: "intermediateprice") == nil {
            UserDefaults.standard.set(intermediatePrice, forKey: "intermediateprice")
        }
        if UserDefaults.standard.string(forKey: "advancedprice") == nil {
            UserDefaults.standard.set(advancedPrice, forKey: "advancedprice")
        }

        FIRApp.configure()

        self.CheckDataBaseOnPathorNot()
        return true
    }

    func CheckDataBaseOnPathorNot() -> Void {
        let bundlePath = Bundle.main.path(forResource: "30DayChallenge", ofType: "json")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("30DayChallenge.json")
        let fullDestPathString = fullDestPath!.path
        if fileManager.fileExists(atPath: fullDestPathString) {
        } else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
            } catch {
                print(error)
            }
        }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    }
}
